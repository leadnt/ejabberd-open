-module(ejabberd_rpc_share).

-include("ejabberd.hrl").
-include("logger.hrl").

-export([send_message/1]).

-record(muc_online_room, {name_host = {<<"">>, <<"">>} :: {binary(), binary()} | '$1' |{'_', binary()} | '_', pid = self() :: pid() | '$2' | '_' | '$1'}).


send_message(Arg) ->
	Type = proplists:get_value("Type", Arg),
    From = proplists:get_value("From", Arg),
    To = proplists:get_value("To", Arg),
    Body = proplists:get_value("Body", Arg),
    MsgType = proplists:get_value("Msg_Type", Arg),
    Host = proplists:get_value("Host", Arg, ?LSERVER),
    Domain = proplists:get_value("Domain", Arg),
    ExtendInfo = proplists:get_value("Extend_Info", Arg, <<"">>),
	Server = ?LSERVER,
    case Type of 
        <<"groupchat">> ->
            send_muc_msg(Server,From,To,Domain,Body,ExtendInfo,MsgType);
        _ ->
            send_chat_msg(Server,From,To,Host, Body,MsgType,ExtendInfo)
    end.

send_chat_msg(Server,From,To, Host, Body,Msg_Type,Extend_Info) ->
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
							Bid = "share_" ++ uuid:to_string(uuid:uuid1()), 
							Packet = make_send_packet(JTo,Body,Extend_Info,Msg_Type, Bid),
							ejabberd_router:route(JFrom,JTo,Packet),
							Packet1 = make_carbon_packet(JFrom,Body,Extend_Info,Msg_Type, Bid),
							ejabberd_router:route(JTo,JFrom,Packet1)
				end	end,To)
		end;
	false -> error
	end.

make_send_packet(To,Msg,ExtendInfo,undefined, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>},{<<"extendInfo">>,ExtendInfo}],[{xmlcdata, Msg}]}]});
make_send_packet(To,Msg,ExtendInfo,MsgType, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,MsgType},{<<"extendInfo">>,ExtendInfo}],[{xmlcdata, Msg}]}]}).

make_carbon_packet(To,Msg,ExtendInfo, undefined, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)},{<<"carbon_message">>,<<"true">>}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>, <<"1">>},{<<"extendInfo">>,ExtendInfo}],[{xmlcdata, Msg}]}]});
make_carbon_packet(To,Msg,ExtendInfo,MsgType, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"chat">>},{<<"to">>,jlib:jid_to_string(To)},{<<"carbon_message">>,<<"true">>}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,MsgType},{<<"extendInfo">>,ExtendInfo}],[{xmlcdata, Msg}]}]}).

is_suit_from(_From) ->
	true.	

send_muc_msg(Server,User,Room,Domain,Body,Extend_Info,Msg_Type) ->
	case is_suit_from(User) of
	true ->
		case Room of
			[{struct,[{"User",Muc}]}] ->
				case get_user_room_rescource(str:concat(<<"conference.">>,Server), User, Server, Muc, Domain) of
					[] -> error;
					Rescoures when is_list(Rescoures)->
						Rs = hd(Rescoures),
						case  jlib:make_jid(User,Server,Rs) of
							error -> error;
							JFrom ->
								case jlib:make_jid(Muc,Domain,<<"">>) of 
									error -> error;
									JTo ->
										Bid = "share_" ++ uuid:to_string(uuid:uuid1()), 
										Packet = make_muc_packet(JTo,Body,Extend_Info,Msg_Type, Bid),
										ejabberd_router:route(JFrom,JTo,Packet)
								end
						end
				end;
			_ -> error
		end;
	false -> error
	end.

make_muc_packet(To,Msg,Extend_Info,undefined, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"groupchat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,<<"1">>},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]});
make_muc_packet(To,Msg,Extend_Info,Msg_Type, Bid) ->
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,<<"groupchat">>},{<<"to">>,jlib:jid_to_string(To)}],
				[{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_Type},{<<"extendInfo">>,Extend_Info}],[{xmlcdata, Msg}]}]}).

get_user_room_rescource(Server,User,Host,Room,Domain) when Server =:= Domain ->
	case mod_muc_room:muc_user_online_rescource(Host,User,Room) of
		[] ->
			case mnesia:dirty_read(muc_online_room, {Room,Domain}) of
				[M] when is_record(M,muc_online_room) ->
					Pid = M#muc_online_room.pid,
					case gen_fsm:sync_send_all_state_event(Pid,{get_muc_user_rescource,User,Host}) of
						{ok,Ret} -> Ret;
						_ -> []
					end;
				_ -> []
			end;
		N when is_list(N) ->
	    	N;
		_ -> []
	end;
get_user_room_rescource(_Server, User, Host, _Room, _Domain) ->
	case ejabberd_sm:get_user_resources(User,Host) of
	[] ->
		[<<"">>];
	L ->
		L
	end.
