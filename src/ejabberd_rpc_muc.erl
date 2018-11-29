-module(ejabberd_rpc_muc).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

-export([
         send_update_vcard_presence/1,
         create_muc/1,
         add_muc_users/1,
         destroy_muc/1,
         get_increment_users/1,
         get_muc_info/1
        ]).

-record(muc_online_room,
          {name_host = {<<"">>, <<"">>} :: {binary(), binary()} | '$1' |{'_', binary()} | '_', pid = self() :: pid() | '$2' | '_' | '$1'}).

send_update_vcard_presence(Arg) ->
    MucName = get_binary_value("muc_name", Arg),
    RoomServer = str:concat(<<"conference.">>, ?LSERVER),
    NewMucName =
            case str:str(MucName,<<"@conference.">>) of
            0 ->
                MucName;
            N ->
                str:substr(MucName,1,N-1)
            end,
    case mnesia:dirty_read(muc_online_room, {NewMucName,RoomServer}) of
    [] ->
            ok;
    [R] ->
        ?INFO_MSG("~p  send_update_vcard_presence ~p ~n",[MucName, NewMucName]),
        Pid = R#muc_online_room.pid,
        Pid ! muc_vcard_update
    end,

    ok.

create_muc(Arg) ->
    Server = ?LSERVER,
    MucName =      get_binary_value("muc_name", Arg),
    MucId =        get_binary_value("muc_id", Arg),
    MucOwner =     get_binary_value("muc_owner", Arg),
    Domain =        get_binary_value("muc_domain", Arg),
    Desc =          get_binary_value("muc_desc", Arg),
    Pic =           get_binary_value("muc_pic", Arg),

    case http_muc_session:check_muc_exist(Server,MucId) of
    false ->
        Packet = http_muc_session:make_create_muc_iq(),
        case jlib:make_jid(MucId,Domain,<<"">>) of
            error -> ?ERROR_MSG("create muc fail for bad mucjid ~p~n", [MucId]);
            ToOwner ->
               Owner = jlib:make_jid(MucOwner,Server,<<"">>),
               catch ejabberd_router:route(Owner,ToOwner, Packet),
               qtalk_sql:insert_muc_vcard_info(Server,qtalk_public:concat(MucId,<<"@">>,Domain),MucName,Desc,<<"">>, Pic,<<"1">>),
               PersistentPacket = http_muc_session:make_muc_persistent(),
               http_muc_vcard_presence:send_update_vcard_presence(MucId),
               catch ejabberd_router:route(jlib:make_jid(MucOwner,Server,<<"">>),jlib:jid_replace_resource(ToOwner,<<"">>), PersistentPacket)	
        end;
    _ -> ?ERROR_MSG("create muc fail for already exist ~p~n", [MucId])
    end.

add_muc_users(Arg) ->
    Server = ?LSERVER,
    MucId =        get_binary_value("muc_id", Arg),
    MucOwner =     get_binary_value("muc_owner", Arg),
    MucMember =    proplists:get_value("muc_member", Arg, []),
    Domain =        get_binary_value("muc_domain", Arg),

    case http_muc_session:check_muc_exist(Server,MucId) of
    true ->
        MucJid = jlib:make_jid(MucId,Domain,<<"">>),
        InviteJid = jlib:make_jid(MucOwner,Server,<<"">>),
        lists:foreach(fun(User) ->
            IQPacket = http_muc_session:make_invite_iq(User, Server),
            ?DEBUG("From ~p ,To ~p,Packet ~p ~n",[InviteJid,MucJid,IQPacket]),
            catch ejabberd_router:route(InviteJid,MucJid,IQPacket)
        end, MucMember);
    _ -> ?ERROR_MSG("add muc users fail for doesn't exist ~p~n", [MucId])
    end.

get_increment_users(Arg) ->
    Server = ?LSERVER,
    MucId =        get_binary_value("muc_id", Arg),
    MucUser =      get_binary_value("muc_owner", Arg),
    From = jlib:make_jid(MucUser, Server, <<"">>),
    FromString = jlib:jid_to_string(From),
    To = jlib:make_jid(MucId, <<"conference.ejabhost2">>, <<"">>),
    ToString = jlib:jid_to_string(To),
    Domain =        get_binary_value("muc_domain", Arg),

    lists:foreach(fun(U) -> 
        Packet = #xmlel{name = <<"iq">>,
                        attrs = [{<<"type">>, <<"set">>},
                                 {<<"to">>, ToString},
                                 {<<"id">>, <<"1">>}],
                        children = [ 
                                #xmlel{name = <<"query">>,
                                       attrs = [{<<"xmlns">>, ?NS_MUC_ADMIN}],
                                       children = [#xmlel{name = <<"item">>,
                                                          attrs = [{<<"real_jid">>, iolist_to_binary([U, "@ejabhost2"])}, {<<"nick">>, list_to_binary(U)}, {<<"role">>, <<"none">>}], 
                                                          children = []}]}]},
        mod_muc:route(From, To, Packet)
    end, proplists:get_value("muc_member", Arg, [])).

destroy_muc(Arg) ->
    Server = ?LSERVER,
    Room = http_muc_session:get_value("muc_id",Arg,<<"">>),
    ServerHost = http_muc_session:get_value("muc_domain",Arg,<<"conference.ejabhost2">>),
    MucOwner = http_muc_session:get_value("muc_owner",Arg,<<"">>),
    Host = http_muc_session:get_value("host",Arg,<<"ejabhost2">>),
    Owner = jlib:jid_to_string({MucOwner,Host,<<"">>}),
    
    case mod_muc:check_muc_owner(Host,Room,Owner) of
    true ->
        case mnesia:dirty_read(muc_online_room, {Room,ServerHost}) of
        [] ->
	    mod_muc:forget_room(Server,ServerHost ,Room),
	    catch qtalk_sql:restore_muc_user_mark(Server,Room),
            catch qtalk_sql:del_muc_users(Server,Room),
            catch qtalk_sql:del_user_register_mucs(Server,Room),
            catch qtalk_sql:del_muc_vcard_info(Server,Room,<<"Admin Destroy">>);
        [M] ->
            ?INFO_MSG("Destory Room ~s  by management cmd ~n",[Room]),
            Pid = M#muc_online_room.pid,
            gen_fsm:send_all_state_event(Pid, {destroy, <<"management close">>}),
            mod_muc:room_destroyed(ServerHost, Room,Pid, Server),
            mod_muc:forget_room(Server,ServerHost ,Room),
            catch qtalk_sql:restore_muc_user_mark(Server,Room),
            catch qtalk_sql:del_muc_users(Server,Room),
            catch qtalk_sql:del_user_register_mucs(Server,Room),
            catch qtalk_sql:del_muc_vcard_info(Server,Room,<<"Admin Destroy">>)
        end;
    _ -> ?ERROR_MSG("owner check fail for ~p~n", [Owner])
    end.

get_muc_info(Arg) ->
    Server = ?LSERVER,
    MucId =        get_binary_value("muc_id",Arg),
    ServerHost =       get_binary_value("muc_domain",Arg),

    SName = ejabberd_sql:escape(MucId),
    SHost = ejabberd_sql:escape(ServerHost),
    MucUsers = case catch qtalk_sql:get_muc_users(Server,SName) of
        {selected, _, Res} when is_list(Res) ->
            lists:map(fun([U,_H]) ->
                U 
            end,Res);
        _ -> []
    end,

    Owners = case catch qtalk_sql:get_muc_opts(Server,SName,SHost) of
        {selected,[<<"opts">>],[[Opts]]} ->
            BOpts = mod_muc:opts_to_binary(ejabberd_sql:decode_term(Opts)),
            Users = proplists:get_value(affiliations,BOpts),
            lists:flatmap(fun({{U,_S,_R},{Aff,_J}}) ->
                if Aff =:= owner  -> [U];
                true -> []
                end
            end,Users);
        _ -> []
    end,
    [{"MucUsers", MucUsers}, {"Owners",Owners}].

get_binary_value(Key, List) ->
    get_binary_value(Key, List, <<"">>).

get_binary_value(Key, List, Default) ->
    list_to_binary(proplists:get_value(Key, List, Default)).


del_muc_users(LServer, Tabname, MucName, Users) ->
	ejabberd_sql:sql_query(LServer,
		[<<"delete from ">>,Tabname,<<" where muc_name = '">>,MucName,<<"' and username in ">>|Users]).
