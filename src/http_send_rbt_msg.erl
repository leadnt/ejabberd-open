%% Feel free to use, reuse and abuse the code in this file.

-module(http_send_rbt_msg).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-include("ejabberd.hrl").
-include("logger.hrl").

-record(user_rbts,{name,rbt}).

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, _} = cowboy_req:method(Req),
	case Method of 
	<<"GET">> ->
	    {Host,_} =  cowboy_req:host(Req),
		{ok, Req1} = get_echo(Method,Host,Req),
		{ok, Req1, State};
	<<"POST">> ->
		HasBody = cowboy_req:has_body(Req),
		{ok, Req1} = post_echo(Method, HasBody, Req),
		{ok, Req1, State};
	_ ->
		{ok,Req1} = echo(undefined, Req),
		{ok, Req1, State}
	end.
    	
get_echo(<<"GET">>,_,Req) ->
		cowboy_req:reply(200, [
			{<<"content-type">>, <<"text/json; charset=utf-8">>}
		], <<"No GET method">>, Req).

post_echo(<<"POST">>, true, Req) ->
    {ok, Body, _} = cowboy_req:body(Req),
	case rfc4627:decode(Body) of
	{ok,{obj,Args},[]} -> 
			Res = http_send_message(Args),
			cowboy_req:reply(200, [	{<<"content-type">>, <<"text/json; charset=utf-8">>}], Res, Req);
	_ ->
		 cowboy_req:reply(200, [ {<<"content-type">>, <<"text/json; charset=utf-8">>}], <<"Josn parse error">>, Req)
	end;
post_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], <<"Missing Post body.">>, Req);
post_echo(_, _, Req) ->
	cowboy_req:reply(405, Req).
										

echo(undefined, Req) ->
    cowboy_req:reply(400, [], <<"Missing parameter.">>, Req);
echo(Echo, Req) ->
    cowboy_req:reply(200, [
			        {<<"content-type">>, <<"text/json; charset=utf-8">>}
	    			    ], Echo, Req).

terminate(_Reason, _Req, _State) ->
	ok.

http_send_message(Json) ->
	Servers = ejabberd_config:get_myhosts(),
	Server = lists:nth(1,Servers),
	http_send_message(Server,Json).	

http_send_message(Server,Args)->
	From = proplists:get_value("From",Args),
	To = proplists:get_value("To",Args),
	Body  = proplists:get_value("Body",Args),
	Msg_type  = proplists:get_value("MsgType",Args),
	ExtendInfo  = proplists:get_value("ExtendInfo",Args,<<"">>),
	Chat_type  = proplists:get_value("Type",Args,<<"chat">>),
	Type = 
		case Msg_type of 
		undefined ->
			<<"1">>;
		_ ->
			Msg_type
		end,
	case is_suit_from(From)  of
	true ->
		case To of
		undefined ->
			http_utils:gen_result(false, <<"-1">>, <<"Json not find To">>);
		<<"subscription_users">> ->
			send_msg_to_all_subscription(Server,From,Body,Type,ExtendInfo);
		_ ->
            send_rbt_msg(Chat_type,Server,From,To,Body,Type,ExtendInfo,Args)  
	    end;
	false ->	
		http_utils:gen_result(false, <<"-1">>, <<"From not suit">>)
	end.

%make_send_packet(To,Msg,Msg_type) ->
 %   make_send_packet(To,Msg,Msg_type,<<"subscription">>).

make_send_packet(<<"">>,To,Msg,Msg_type,Type) ->
%%	Bid = list_to_binary("rbts_" ++  [jlib:integer_to_binary(X) || X <- tuple_to_list(os:timestamp())]),
    Bid = list_to_binary("rb" ++ binary_to_list(randoms:get_string()) ++ integer_to_list(qtalk_public:get_exact_timestamp())),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,Type},{<<"to">>,jlib:jid_to_string(To)},{<<"direction">>,<<"1">>}],
				[{xmlel,<<"active">>,[{<<"xmlns">>,<<"http://jabber.org/protocol/chatstates">>}],[]},
					{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_type}],[{xmlcdata, Msg}]}]});
make_send_packet(ExtendInfo,To,Msg,Msg_type,Type) ->
%%	Integer = random:uniform(65536),
%	Bid = list_to_binary("rbts_" ++  [jlib:integer_to_binary(X) || X <- tuple_to_list(os:timestamp())]),
    Bid = list_to_binary("rb" ++ binary_to_list(randoms:get_string()) ++ integer_to_list(qtalk_public:get_exact_timestamp())),
	fxml:to_xmlel(
			{xmlel	,<<"message">>,	[{<<"type">>,Type},{<<"to">>,jlib:jid_to_string(To)},{<<"direction">>,<<"1">>}],
				[{xmlel,<<"active">>,[{<<"xmlns">>,<<"http://jabber.org/protocol/chatstates">>}],[]},
					{xmlel,<<"body">>,[{<<"id">>,Bid},{<<"msgType">>,Msg_type},{<<"extendInfo">>,ExtendInfo}],[{xmlcdata, Msg}]}]}).

is_suit_from(_From) ->
	true.	

send_msg_to_all_subscription(Server,From,Body,Msg_type,ExtendInfo) ->
	case catch ets:select(user_rbts,[{#user_rbts{rbt = From,name = '$1', _ = '_'},[], ['$1']}]) of
	Users when is_list(Users) ->
		lists:foreach(fun(U) ->
			sendMsg(Server,Server,From,U,Body,Msg_type,<<"subscription">>,ExtendInfo) end,Users),
		http_utils:gen_result(true, <<"0">>, <<"Send message Ok">>);
	_ ->
		http_utils:gen_result(false, <<"-1">>, <<"Send message failed">>)
	end.

sendMsg(Server,Domain,From,To,Body,Msg_type,Type,ExtendInfo) ->
	case Body of
	undefined ->
			[str:concat(To,<<"Message Body is Null">>)];
	_ ->
			JFrom = jlib:make_jid(From,Server,<<"">>),
			case JFrom of 
			error ->
				[str:concat(From,<<"From make jid error">>)];
			_ ->
				case jlib:make_jid(To,Domain,<<"">>) of 
				error ->
					[str:concat(To,<<"To make jid error">>)];
				JTo ->
					Packet = make_send_packet(ExtendInfo,JTo,Body,Msg_type,Type),
					ejabberd_router:route(JFrom,JTo,Packet),
					[]
				end
			end
	end.

check_legal_touser(Server,Rbt,JTo) ->
	case catch ets:select(user_rbts,[{#user_rbts{name = JTo,rbt = Rbt, _ = '_'},[], [[]]}]) of
	[] ->
		case catch ejabberd_sql:sql_query(Server,
			[<<"select user_name from robot_pubsub where rbt_name = '">>,Rbt,<<"' and user_name = '">>,JTo,<<"';">>]) of
		{selected,[<<"user_name">>],[]} ->
			false;
		{selected, [<<"user_name">>], SRes1} when is_list(SRes1) ->
			ets:insert(user_rbts,#user_rbts{name = Rbt,rbt = JTo}),
			true;
		_ ->
			false
		end;
	[[]] ->
		true
	end.

send_rbt_msg(<<"chat">>,Server,From,To,Body,Type,ExtendInfo,_Args) ->
    Tos =  str:tokens(To,<<",">>),
	Rslt = 
	    lists:flatmap(fun(T) ->
	        sendMsg(Server,Server,From,T,Body,Type,<<"subscription">>,ExtendInfo) end,Tos),
	case Rslt of
	[] ->
		http_utils:gen_result(true,<<"0">>,Rslt);
	_ ->
	    http_utils:gen_result(false,<<"-1">>,Rslt)
    end;
send_rbt_msg(<<"groupchat">>,Server,From,To,Body,Type,ExtendInfo,Args)  ->
    case proplists:get_value("Domain",Args) of
    undefined ->
        http_utils:gen_result(false,<<"-1">>,[]);
    Domain ->
        Rslt = sendMsg(Server,Domain,From,To,Body,Type,<<"groupchat">>,ExtendInfo),
        case Rslt of
        [] ->
            http_utils:gen_result(true,<<"0">>,Rslt);
        _ ->
            http_utils:gen_result(false,<<"-1">>,Rslt)
        end
    end;
send_rbt_msg(_,_Server,_From,_To,_Body,_Type,_Args,ExtendInfo) ->
     http_utils:gen_result(true,<<"0">>,[]).
