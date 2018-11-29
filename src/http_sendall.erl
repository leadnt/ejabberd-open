%% Feel free to use, reuse and abuse the code in this file.

-module(http_sendall).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-export([http_send_message/2,http_send_message/3]).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

-record(department_users,{dep1,dep2,dep3,dep4,dep5,user}).

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
	{Online,_} = cowboy_req:qs_val(<<"online">>, Req),
	case rfc4627:decode(Body) of
	{ok,[{obj,Args}],[]} -> 
		Res = http_send_message(Args,Online),
		cowboy_req:reply(200, [{<<"content-type">>, <<"text/json; charset=utf-8">>}], Res, Req);
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

http_send_message(Json,Flag)->
    Servers = ejabberd_config:get_myhosts(),
    Server = lists:nth(1,Servers),
	http_send_message(Server,Json,Flag).
	
http_send_message(Server,Args,Online)->
	From = proplists:get_value("From",Args),
	Body  = proplists:get_value("Body",Args),
	Res = 
		case is_suit_from(From) of
		true ->
			case Body of
			undefined ->
				rfc4627:encode({obj,[{"data",<<"Message Body is Null">>}]});
			_ ->
				JFrom = jlib:make_jid(From,Server,<<"">>),
				case JFrom of 
				error ->
					rfc4627:encode({obj,[{"data",<<"From make jid error">>}]});
				_ ->
					http_send_notice(Online,Server,JFrom,Body) 
				end
			end;
		false ->	
    	    Us2 = {obj,[{"data",<<"From not suit">>}]},
    	    rfc4627:encode(Us2)
		end,
      list_to_binary(Res).

is_suit_from(_From) ->
	true.

http_send_notice(<<"false">>,Server,JFrom,Body)  ->
	Packet = qtalk_public:make_message_packet(<<"headline">>,Body,<<"1">>,<<"1">>),
	Users = 
		 case catch ets:select(department_users,[{#department_users{user = '$2',dep1 = '$1', _ = '_'}, [{'==', '$1', Server}], ['$2']}]) of
		 [] ->
		 	[];
		 UL when is_list(UL) ->
		 	UL;
		 _ ->
		 	[]
		 end,
	lists:foreach(fun(U) ->
			 case jlib:make_jid(U,Server,<<"">>) of
			 error ->
				 	ok;
			 JTo ->
				 	ejabberd_router:route(JFrom,JTo,Packet)
			end
		end,Users),
    catch log_noticemsg(Server,Packet),
	rfc4627:encode({obj,[{"data",<<"Send Message Ok">>}]});
http_send_notice(_ ,Server,JFrom,Body) ->
	Packet = qtalk_public:make_message_packet(<<"headline">>,Body,<<"1">>,<<"1">>),
	Uers = ejabberd_sm:get_vh_session_list(Server),
	lists:foreach(fun({U,S,R}) ->
		case jlib:make_jid(U,S,R) of
		error ->
			ok;
		JTo ->
			ejabberd_router:route(JFrom,JTo,Packet)
		end
	end ,Uers),
    catch log_noticemsg(Server,Packet),
	rfc4627:encode({obj,[{"data",<<"Send Message Ok">>}]}).



log_noticemsg(LServer,Packet) ->
    #xmlel{name = Name, attrs = Attrs, children = Els} = Packet,
    Now = qtalk_public:get_exact_timestamp(), 

    NewPacket = ejabberd_sm:add_msectime_to_packet(Name,Attrs,Els,Now),
    MsgID = fxml:get_tag_attr_s(<<"id">>, fxml:get_subtag(NewPacket,<<"body">>)),
    Time = qtalk_public:pg2timestamp(Now),
    ?DEBUG("notice packet ~p ~n",[Packet]),
    case catch fxml:element_to_binary(NewPacket) of
    BPacket when is_binary(BPacket)  ->
        catch ejabberd_sql:sql_query(LServer,
                [<<"insert into notice_history(m_from,host,m_body,msg_id,create_time) values ('admin','">>,LServer,<<"','">>
                        ,ejabberd_sql:escape(BPacket),<<"','">>,MsgID,<<"',">>,Time,<<");">>]); 
    Err ->
        ?INFO_MSG("insert notice msg error ~p ,~p ~n",[Err,NewPacket])
    end.
    

