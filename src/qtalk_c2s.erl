%%%----------------------------------------------------------------------
%%%%%% File    : qtalk_c2s.erl
%%% add qtalk c2s function
%%%----------------------------------------------------------------------
-module(qtalk_c2s).

-include("ejabberd.hrl").
-include("logger.hrl").

-include("jlib.hrl").

-export([check_lan_version/2,set_redis_user_key/6,make_time_key_presence/1]).
-export([make_new_PresenceEl/4,carbon_message/3,get_presence_show_tag/1,check_consult_from/3]).


%%%%%%%%%%%-----------------------------------------------------------
%%%%%%%%%%% @date 2017-03
%%%%%%%%%%% 检查版本信息
%%%%%%%%%%%-----------------------------------------------------------
check_lan_version(Resource,Version) ->
    Platform = qtalk_public:get_lan_platform(Resource),
    do_check_lan_version(Platform,Resource,Version).

do_check_lan_version(<<"MAC">>,_Resource,_Version) ->
    true;
do_check_lan_version(<<"QIM_PC">>,_Resource,_Version) ->
    true.

%%%%%%%%%%%-----------------------------------------------------------
%%%%%%%%%%% @date 2017-03
%%%%%%%%%%% 设置redis用户key,用于http鉴权
%%%%%%%%%%%-----------------------------------------------------------
set_redis_user_key(Server,User,Resource,Key,Mac_key,Time) ->
    catch redis_link:hash_set(Server,1,User,Resource,Key),
%    catch redis_link:expire_time(Server,1,User,Time),
    FUser = qtalk_public:concat(User,<<"@">>,Server),
    catch redis_link:hash_set(Server,2,FUser,Key,Mac_key),
    catch redis_link:hash_set(Server,2,User,Key,Mac_key).
 %   catch redis_link:expire_time(Server,2,User,Time).


%%%%%%%%%%%-----------------------------------------------------------
%%%%%%%%%%% @date 2017-03
%%%%%%%%%%% 生成time/key Presence
%%%%%%%%%%%-----------------------------------------------------------
make_time_key_presence(Key) ->
    Time = integer_to_binary(qtalk_public:get_timestamp()),
    #xmlel{name = <<"presence">>,
        attrs = [{<<"xmlns">>,?CONFIG_XMPP_TIME_KEY},{<<"time_value">>,Time},{<<"key_value">>,Key}],
        children = []}.


%%%%%%%%%%%-----------------------------------------------------------
%%%%%%%%%%% @date 2017-03
%%%%%%%%%%% 生成 PresenceEl
%%%%%%%%%%%-----------------------------------------------------------
make_new_PresenceEl(Server,User, El, Attrs) ->
    case catch fxml:get_attr_s(<<"xmlns">>, Attrs) of
    ?NS_VER_FRI ->
        El;
    ?NS_MUC_INVITE ->
        El;
    ?NS_MUC_DEL_REGISTER->
        El;
    ?NS_NOTIFY -> El;
    _ ->
        ejabberd_hooks:run_fold(c2s_update_presence,
            Server, El,[User, Server])
    end.

%%%%%%%%%%%-----------------------------------------------------------
%%%%%%%%%%% @date 2017-03
%%%%%%%%%%% 处理Carbon消息
%%%%%%%%%%%-----------------------------------------------------------
carbon_message(From,To,Packet) ->
    #xmlel{name = Name, attrs = Attrs, children = Els} = Packet,
    ReadType = fxml:get_attr_s(<<"read_type">>, Attrs),
    Type = fxml:get_attr_s(<<"type">>, Attrs),
    case ejabberd_sm:get_user_resources(From#jid.user,From#jid.server) of
    Resources  when is_list(Resources) ->
        if Type =:= <<"normal">> ; Type =:= <<"chat">>; Type =:= <<"revoke">>; Type =:= <<"note">> ;Type =:= <<"consult">>; Type =:= <<"encrypt">> ->
            case str:str(To#jid.server,<<"conference">>) =:= 0 andalso fxml:get_attr_s(<<"auto_reply">>, Attrs) =/= <<"true">>
                andalso fxml:get_attr_s(<<"carbon_message">>, Attrs) =/= <<"true">>  of
                true -> do_carbon_message(From, To, Packet, Resources);
                _ -> ok
            end;
        ReadType =:= <<"4">>, Type =:= <<"readmark">> -> do_carbon_message(From, To, Packet, Resources);
        true -> ok
        end;
    _ ->
        ok
    end.

do_carbon_message(From, To, Packet, Resources) ->
    #xmlel{name = Name, attrs = Attrs, children = Els} = Packet,
    Rs = Resources -- [From#jid.lresource],
    lists:foreach(fun(R) ->
                case jlib:make_jid(From#jid.user,From#jid.server,R) of
                    error -> ok;
                    NewFrom ->
                        Attrs1 = jlib:replace_from_to_attrs(jlib:jid_to_string(NewFrom),jlib:jid_to_string(To), Attrs),
                        Attrs2 = lists:append([Attrs1,[{<<"carbon_message">>,<<"true">>}]]),
                        NewPacket = #xmlel{name = Name, attrs = Attrs2, children = Els },
                        ejabberd_router:route(To, NewFrom, NewPacket)
                end
    end ,Rs).

%carbon_consult_msg(From,To,Packet,Resoureces) ->
%    #xmlel{attrs = Attrs,name = Name,children = Children} = Packet,
%    case  fxml:get_attr_s(<<"carbon_message">>, Attrs) of
%    <<"true">> ->
%        ok;
%    _ ->
%        Rs = Resoureces -- [From#jid.lresource],
%        lists:foreach(fun(R) ->
%            NewTo = jlib:jid_replace_resource(From,R),
%            Attrs1 = jlib:replace_from_to_attrs(jlib:jid_to_string(To), jlib:jid_to_string(NewTo), Attrs),
%            NewPacket = #xmlel{name = Name, attrs = [{<<"carbon_message">>,<<"true">>}|Attrs1], children = Children},
%            ejabberd_router:route(To, NewTo, NewPacket) end,Rs)
%    end.


clear_redis_user_key(Server,User,Resource) when Server =:= <<"">> ; User =:= <<"">>; Resource =:= <<"">> ->
	ok;
clear_redis_user_key(Server,User,Resource)  ->
    case catch redis_link:hash_get(Server,1,User,Resource) of
    {ok,undefined} ->
                    ok;
    {ok,Key} ->
                    redis_link:hash_del(Server,1,User,Resource),
    		    FUser = qtalk_public:concat(User,<<"@">>,Server),
                    catch redis_link:hash_del(Server,2,FUser,Key),
                    redis_link:hash_del(Server,2,User,Key);
     _ ->
                    ok
     end.

get_presence_show_tag(Presence) ->
    case fxml:get_path_s(Presence, [{elem, <<"show">>}, cdata]) of
    <<"away">> -> <<"away">>;
    <<"offline">> -> <<"offline">>;
    <<"busy">> -> <<"busy">>;
    <<"checkout">> -> <<"checkout">>;
    <<"checkin">> -> <<"checkin">>;
    <<"push">> -> <<"push">>;
    <<"online">> -> <<"online">>;
    <<"normal">> -> <<"normal">>;
    _ -> <<"unknown">>
    end.

del_muc_spool() ->
    ok.

send_user_refused_msg() ->
    ok.

make_recv_reply_packet() ->
    ok.

make_new_presence_packet() ->
    ok.

kick_lower_version_user() ->
    ok.


check_consult_from(El,From,JID) ->
	#xmlel{name = Name} = El,
	case Name of
	<<"message">> ->
		case catch fxml:get_tag_attr_s(<<"type">>, El) of
		<<"consult">> ->
			El;
		_ ->
			'invalid-from'
		end;
	_ ->
		'invalid-from'
	end.
