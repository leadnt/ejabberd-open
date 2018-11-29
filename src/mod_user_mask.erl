-module(mod_user_mask).

-behavior(gen_mod).

-include("ejabberd.hrl").
-include("logger.hrl").

-include("jlib.hrl").

%% gen_mod callbacks
-export([start/2, stop/1]).
-export([depends/2, mod_opt_type/1]).
-export([handle_mask_user/3]).

%%====================================================================
stop(Host) ->
    _ = gen_mod:get_module_proc(Host, ?MODULE),
    catch ets:delete(user_mask_list),

    gen_iq_handler:remove_iq_handler(ejabberd_local, Host, ?NS_MASK_USER),
    gen_iq_handler:remove_iq_handler(ejabberd_sm, Host, ?NS_MASK_USER).

start(Host, Opts) ->
    catch ets:new(user_mask_list, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
    IQDisc = gen_mod:get_opt(iqdisc, Opts, fun gen_iq_handler:check_type/1,one_queue),


    gen_iq_handler:add_iq_handler(ejabberd_sm, Host, ?NS_MASK_USER, ?MODULE, handle_mask_user, IQDisc),
    gen_iq_handler:add_iq_handler(ejabberd_local, Host, ?NS_MASK_USER, ?MODULE, handle_mask_user, IQDisc).

handle_mask_user(From, _To, #iq{type = Type, sub_el = SubEl} = IQ) 	->
    case {Type, SubEl} of
        {get, #xmlel{name = <<"mask_user">>}} -> IQ#iq{type = result, sub_el = get_mask_user(From)};
        {set, #xmlel{name = <<"mask_user">>}} -> IQ#iq{type = result, sub_el = [set_mask_user(From,SubEl)]};
        {set, #xmlel{name = <<"cancel_mask_user">>}} -> IQ#iq{type = result, sub_el = [cancel_mask_user(From,SubEl)]};
        _ -> IQ#iq{type = error,sub_el = [SubEl, ?ERR_FEATURE_NOT_IMPLEMENTED]}
    end.

get_mask_user(From) ->
    User = From#jid.user,
    LServer = jlib:nameprep(From#jid.server),
    UL = case ets:lookup(user_mask_list,jlib:jid_to_string({User,LServer,<<"">>})) of
        [{_,L}] when is_list(L) -> L;
        _ -> []
    end,

    Res = lists:map(fun(U) ->
        #xmlel{name = <<"get_mask_user">>,
               attrs = 	[{<<"xmlns">>,?NS_MASK_USER},{<<"masked_user">>,U}],
               children = []}
    end, UL),

    [#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"jabber:x:mask_user_v2">>}],children = []}]++ Res.

set_mask_user(From,El) ->
    LServer = jlib:nameprep(From#jid.server),
    User = jlib:jid_to_string({From#jid.luser,LServer,<<"">>}),
    V = case fxml:get_tag_attr_s(<<"jid">>,El) of
        <<"">> -> <<"failed">>;
        J ->
            XMLNS = ?NS_MASK_USER,
            Name = <<"mask_user">>,
            Attrs = [{<<"jid">>,J}],
            send_presence_notice(From,XMLNS,Name,Attrs),
            mod_update_v2:update_user_mask(LServer,User,J,true),
            lists:foreach(fun(ONode) ->
	        catch sync_ets_cache:send_sync_node_notcie(LServer,ONode,mod_update_v2,update_user_mask,[LServer,User,J,false])
            end, nodes(visible)),
            <<"success">>
	end,

    #xmlel{name = <<"mask_user">>,
           attrs = [{<<"xmlns">>,?NS_MASK_USER}, {<<"result">>,V}]}.

cancel_mask_user(From,El) ->
    LServer = jlib:nameprep(From#jid.server),
    User = jlib:jid_to_string({From#jid.luser,LServer,<<"">>}),
    V = case fxml:get_tag_attr_s(<<"jid">>,El) of
        <<"">> -> <<"failed">>;
        J ->
            XMLNS = ?NS_MASK_USER,
            Name = <<"cancel_masked_user">>,
            Attrs = [{<<"jid">>,J}],
            send_presence_notice(From,XMLNS,Name,Attrs),
            mod_update_v2:del_user_mask(LServer,User,J,true),
            lists:foreach(fun(ONode) ->
                catch sync_ets_cache:send_sync_node_notcie(LServer,ONode,mod_update_v2,del_user_mask,[LServer,User,J,false])
            end, nodes(visible)),
            <<"success">>
    end,
    #xmlel{name = <<"cancel_mask_user">>,
           attrs = [{<<"xmlns">>,?NS_MASK_USER}, {<<"result">>,V}]}.

send_presence_notice(From,XMLNS,Name,Attrs) ->
    Presence_packet = #xmlel{name = <<"presence">>,
    attrs =[{<<"xmlns">>,XMLNS}],
    children = [#xmlel{name = Name, attrs = Attrs, children = []}]},
    ejabberd_router:route(From, jlib:jid_remove_resource(From), Presence_packet).

depends(_Host, _Opts) ->
    [].

mod_opt_type(_) -> [].
