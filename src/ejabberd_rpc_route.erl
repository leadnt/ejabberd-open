-module(ejabberd_rpc_route).

-include("ejabberd.hrl").
-include("logger.hrl").

-export([
         route/3,
         do_route/4,
         get_online_users_length/1
        ]).

-export([send_message/1,
		 send_ochat_message/1,
		 send_thirdparty_message/1,
	java_send_message/3]).

%%ejabberd_rpc_route:route({"rbt-notice", lists:map(fun(_) -> {"rbt-notice", "nfuhsfi6986"} end, lists:seq(1, 1000))}, {"1", "xxxxxxxx", "sent"}, 'robot').
route(Users, Message, Type) ->
	Bid = list_to_binary("rbts_" ++  [jlib:integer_to_binary(X) || X <- tuple_to_list(os:timestamp())]),
    spawn(?MODULE, do_route, [Users, Message, Type, Bid]),
    Bid.

do_route({"rbt-system", Users}, Message, Type, Bid) ->
    OnlineUsers = get_online_users_length(Users),
    Body = case Message of
        {_MsgType, Msg, _Direction} ->
            Msg;
        Other ->
            Other
    end,

	NewUsers =
    lists:foldl(fun({From, To}, Acc) ->
						case {make_jid(From), make_jid(To)} of
							{JF, JT} when JF =:= error; JT =:= error ->
								Acc;
							{JFrom, JTo} ->
								MsgId = uuid:to_string(uuid:uuid1()),
                        		NewMsg = make_message(Type, JFrom, JTo, MsgId, Message),
				                catch monitor_util:monitor_count(<<"rpc_rbtsystem_chat_message">>,1),
                        		ejabberd_router:route(JFrom, JTo, NewMsg),
								[{{From, To}, MsgId}|Acc]
						end
                    end, [], Users),
    UserLength = length(NewUsers),

    msg_stat(Bid, Body, UserLength, OnlineUsers, NewUsers);
do_route({"rbt-notice", Users}, Message, Type, _Bid) ->
    NewUsers = lists:map(fun({From, To}) ->
                            JFrom = make_jid(From),
                            JTo = make_jid(To),
                            {JFrom, JTo} end, Users),

    lists:foldl(fun({From, To}, N) when From =:= error; To =:= error ->
                        N;
                     ({From, To}, N) ->
			MsgId = uuid:to_string(uuid:uuid1()),
                        NewMsg = make_message(Type, From, To, MsgId, Message),
		        catch monitor_util:monitor_count(<<"rpc_rbtnotice_chat_message">>,1),
                        ejabberd_router:route(From, To, NewMsg),
			if N > 500 -> timer:sleep(1000), 0;
                            true -> N+1
                        end
                    end, 0, NewUsers).

make_message('robot', _From, To, Bid, {MsgType, Msg, Direction}) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"subscription">>},{<<"to">>,jlib:jid_to_string(To)}, {<<"direction">>, to_binary(Direction)}],
				[{xmlel,<<"active">>,[{<<"xmlns">>,<<"http://jabber.org/protocol/chatstates">>}],[]},
					{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>, to_binary(MsgType)}],[{xmlcdata, to_binary(Msg)}]}]});
make_message(_, From, To, Bid, Msg) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)}, {<<"from">>, jlib:jid_to_string(From)}],
				[{xmlel,<<"active">>,[{<<"xmlns">>,<<"http://jabber.org/protocol/chatstates">>}],[]},
					{xmlel,<<"body">>,[{<<"id">>,Bid}],[{xmlcdata, to_binary(Msg)}]}]}).
 
to_binary(Term) when is_binary(Term) ->
    Term;
to_binary(Term) when is_list(Term) ->
    list_to_binary(Term);
to_binary(Term) when is_integer(Term) ->
    integer_to_binary(Term).

make_jid(User) ->
	?INFO_MSG("the user is ~p~n", [User]),
    case jlib:make_jid(to_binary(re:replace(User, "@", "[at]", [{return, list}, global])), ?LSERVER, <<"">>) of
        error ->
            ?ERROR_MSG("the user is invalid for ~p~n", [User]),
            error;
        Jid ->
            Jid
    end.

get_online_users_length(Users) ->
    lists:foldl(fun({_, To}, Acc) ->
                case ejabberd_rpc_session:get_user_status(to_binary(re:replace(To, "@", "[at]", [{return, list}, global]))) of
                    <<"offline">> ->
                        Acc;
                    _ ->
                        [To|Acc]
                end end, [], Users).

%%-----------------------------------------------
%% 未发送消息：       0000
%% 直接发送的消息：   0001
%% 离线发送的消息：   0010
%% ios推送的消息：    0100
%% android推送的消息；1000
%%-----------------------------------------------
msg_stat(Bid, Body, Total, OnlineUsers, Users) ->
	do_msg_stat(Bid, Body, Total, OnlineUsers, Users).

do_msg_stat(_, _, _, _, []) ->
	ok;
do_msg_stat(Bid, Body, Total, OnlineUsers, Users) ->
	{H, T} =
	case length(Users) =< 50 of
		true ->
			{Users, []};
		_ ->
			lists:split(50, Users)
	end,
	
    {[<<_, Rest/binary>>|R], _} =
    lists:foldl(fun({{From, To}, MsgId}, {Acc, Onlines}) ->
                case lists:delete(To, Onlines) of
                    Onlines -> {[<<", ('">>, Bid, <<"', '">>, MsgId, <<"', '">>, From, <<"', '">>, To, <<"', '">>, ejabberd_sql:escape(list_to_binary(Body)), <<"', '0') ">>|Acc], Onlines};
                    NewOnlines -> {[<<", ('">>, Bid, <<"', '">>, MsgId, <<"', '">>, From, <<"', '">>, To, <<"', '">>, ejabberd_sql:escape(list_to_binary(Body)), <<"', '1') ">>|Acc], NewOnlines}
                end
        end, {[], OnlineUsers}, H),

    case catch ejabberd_sql:sql_query(?LSERVER, [<<"insert into rbt_detail_stat (bid, msg_id, fromname, username, message, send_flag) values ">>|[Rest|R]]) of
        {updated, _} ->
            ok;
        Error1 ->
            ?ERROR_MSG("insert into rbt_detail_stat error for ~p, the values is ~p~n", [Error1, [Rest|R]])
    end,

	do_msg_stat(Bid, Body, Total, OnlineUsers, T).
send_thirdparty_message(Arg) ->
	From = proplists:get_value("from", Arg),
	To = proplists:get_value("to", Arg),
	Message = proplists:get_value("message", Arg),
	JFrom = jlib:string_to_jid(From),
	JTo = jlib:string_to_jid(To),
	Packet = fxml_stream:parse_element(Message),
    catch monitor_util:monitor_count(<<"rpc_thirdparty_chat_message">>,1),
	ejabberd_router:route(JFrom,JTo,Packet).


java_send_message(From,To,Message) ->
    ?DEBUG("java send  Message ~p ~n",[unicode:characters_to_binary(Message)]),
        JFrom = jlib:string_to_jid(list_to_binary(From)),
        JTo = jlib:string_to_jid(list_to_binary(To)),
        Packet = fxml_stream:parse_element(unicode:characters_to_binary(Message)),
%    catch monitor_util:monitor_count(<<"rpc_thirdparty_chat_message">>,1),
        ejabberd_router:route(JFrom,JTo,Packet).


send_ochat_message(Arg) ->
    UsrType = proplists:get_value("usrType", Arg),
    From = proplists:get_value("from", Arg),
    To = proplists:get_value("to", Arg),
    BusinessId = proplists:get_value("businessId", Arg),
    Event = proplists:get_value("event", Arg),
    Message = proplists:get_value("message", Arg),
    CN = proplists:get_value("cn", Arg),
    D = proplists:get_value("d", Arg),
    Ctnt = proplists:get_value("ctnt", Arg),
    Carbon = proplists:get_value("carbon", Arg),

    Bid = uuid:to_string(uuid:uuid1()),
    ChannelId = rfc4627:encode({obj, [{"d", D}, {"cn", CN}, {"usrType", UsrType}]}),
    JFrom = jlib:string_to_jid(From),
    JTo = jlib:string_to_jid(To),
    catch monitor_util:monitor_count(<<"rpc_ochat_chat_message">>,1),
    case Carbon of
        true ->
            case BusinessId of
                undefined ->
                        Msg = fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"chat">>},{<<"to">>, To}, {<<"from">>, From}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]}),
                        ejabberd_router:route(JFrom, JTo, Msg),
                        Msg1 = fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"chat">>},{<<"to">>, From}, {<<"from">>, To}, {<<"channelid">>, ChannelId}, {<<"carbon_message">>,<<"true">>}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]}),
                        ejabberd_router:route(JTo, JFrom, Msg1);
                _ ->
                        JBusinessId = jlib:string_to_jid(BusinessId),
                        Msg = case Event of
                                undefined ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, From}, {<<"realfrom">>, From}, {<<"realto">>, To}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"16384">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]});
                                _ ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, From}, {<<"realfrom">>, From}, {<<"realto">>, To}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"32768">>}, {<<"extendInfo">>, Message}, {<<"ochat">>, Message}],[{xmlcdata, Ctnt}]}]})
                        end,
                        ejabberd_router:route(JFrom, JBusinessId, Msg),
                        Msg1 = case Event of
                                undefined ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, To}, {<<"realfrom">>, To}, {<<"realto">>, From}, {<<"channelid">>, ChannelId}, {<<"carbon_message">>,<<"true">>}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"16384">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]});
                                _ ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, To}, {<<"realfrom">>, To}, {<<"realto">>, From}, {<<"channelid">>, ChannelId}, {<<"carbon_message">>,<<"true">>}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"32768">>}, {<<"extendInfo">>, Message}, {<<"ochat">>, Message}],[{xmlcdata, Ctnt}]}]})
                        end,
                        ejabberd_router:route(JBusinessId, JFrom, Msg1)
            end;
        _ ->
            case BusinessId of
                undefined ->
                        Msg = fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"chat">>},{<<"to">>, To}, {<<"from">>, From}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]}),
                        ejabberd_router:route(JFrom, JTo, Msg);
                _ ->
                        JBusinessId = jlib:string_to_jid(BusinessId),
                        Msg = case Event of
                                undefined ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, From}, {<<"realfrom">>, From}, {<<"realto">>, To}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"16384">>}, {<<"extendInfo">>, Message}],[{xmlcdata, Ctnt}]}]});
                                _ ->
                        fxml:to_xmlel(
                        {xmlel  ,<<"message">>, [{<<"type">>,<<"consult">>},{<<"to">>, BusinessId}, {<<"from">>, From}, {<<"realfrom">>, From}, {<<"realto">>, To}, {<<"channelid">>, ChannelId}],
                                [{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"32768">>}, {<<"extendInfo">>, Message}, {<<"ochat">>, Message}],[{xmlcdata, Ctnt}]}]})
                        end,
                        ejabberd_router:route(JFrom, JBusinessId, Msg)
            end
    end.

send_message(Arg) ->
	Type = proplists:get_value("Type", Arg),
    From = proplists:get_value("From", Arg),
    To = proplists:get_value("To", Arg),
    Body = proplists:get_value("Body", Arg),
    MsgType = proplists:get_value("Msg_Type", Arg),
    Host = proplists:get_value("Host", Arg, ?LSERVER),
    Domain = proplists:get_value("Domain", Arg),
    ExtendInfo = proplists:get_value("Extend_Info", Arg, <<"">>),
    Carbon = proplists:get_value("Carbon", Arg, <<"false">>),
    Server = ?LSERVER,
    case Type of 
        <<"groupchat">> ->
            send_muc_msg(Server,From,To,Domain,Body,ExtendInfo,MsgType);
        _ ->
            send_chat_msg(Server,From,To,Host, Body,MsgType,ExtendInfo, Carbon)
    end.

send_chat_msg(Server,From,To, Host, Body,Msg_Type,Extend_Info, <<"true">>) ->
    catch monitor_util:monitor_count(<<"rpc_sendchat_message1">>,1),
	case is_suit_from(From) of
	true ->
		JFrom = jlib:make_jid(From,Server,<<"">>),
		case JFrom of 
			error -> error;
			_ ->
				lists:foreach(fun({struct,[{"User",ToU}]}) ->
					case jlib:make_jid(ToU, Host,<<"">>) of 
						error -> error;
						JTo ->
									Packet = make_send_packet(JTo,Body,Extend_Info,Msg_Type),
									ejabberd_router:route(JFrom,JTo,Packet),
									Packet1 = make_red_ball_packet(JFrom,Body,Extend_Info,Msg_Type),
									ejabberd_router:route(JTo,JFrom,Packet1)
					end
				end,To)
		end;
	false -> error
	end;
send_chat_msg(Server,From,To, Host, Body,Msg_Type,Extend_Info, <<"false">>) ->
    catch monitor_util:monitor_count(<<"rpc_sendchat_message2">>,1),
	case is_suit_from(From) of
	true ->
		JFrom = jlib:make_jid(From,Server,<<"">>),
		case JFrom of 
			error -> error;
			_ ->
				lists:foreach(fun({struct,[{"User",ToU}]}) ->
					case jlib:make_jid(ToU, Host,<<"">>) of 
						error -> error;
						JTo ->
							case Msg_Type of 
								T when T =:= <<"512">>; T =:= <<"513">>; %%红包消息，特殊处理
									   T =:= <<"4096">>  %% 推荐产品消息
									 -> 
									Packet = make_send_packet(JTo,Body,Extend_Info,Msg_Type),
									ejabberd_router:route(JFrom,JTo,Packet),
									Packet1 = make_red_ball_packet(JFrom,Body,Extend_Info,Msg_Type),
									ejabberd_router:route(JTo,JFrom,Packet1);
								_ ->
									Packet = make_send_packet(JTo,Body,Extend_Info,Msg_Type),
									ejabberd_router:route(JFrom,JTo,Packet)
							end
				end	end,To)
		end;
	false -> error
	end.

make_send_packet(To,Msg,Extend_Info,undefined) ->
	Bid = uuid:to_string(uuid:uuid1()),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]});
make_send_packet(To,Msg,Extend_Info,Msg_Type) ->
	Bid = uuid:to_string(uuid:uuid1()),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_Type},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]}).

make_red_ball_packet(To,Msg,Extend_Info,Msg_Type) ->
	Bid = list_to_binary("http_" ++ integer_to_list(qtalk_public:get_exact_timestamp())),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)},{<<"carbon_message">>,<<"true">>}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_Type},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]}).

is_suit_from(_From) ->
	true.	

send_muc_msg(Server,User,Room,Domain,Body,Extend_Info,Msg_Type) ->
	case is_suit_from(User) of
	true ->
		case Room of
			[{struct,[{"User",Muc}]}] ->
						case  jlib:make_jid(User,Server, <<"">>) of
							error -> error;
							JFrom ->
								case jlib:make_jid(Muc,Domain,<<"">>) of 
									error -> error;
									JTo ->
										Packet = make_muc_packet(JTo,Body,Extend_Info,Msg_Type),
										ejabberd_router:route(JFrom,JTo,Packet)
								end
						end;
			_ -> error
		end;
	false -> error
	end.

make_muc_packet(To,Msg,Extend_Info,undefined) ->
	Bid = uuid:to_string(uuid:uuid1()),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"groupchat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]});
make_muc_packet(To,Msg,Extend_Info,Msg_Type) ->
	Bid = uuid:to_string(uuid:uuid1()),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"groupchat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_Type},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]}).
