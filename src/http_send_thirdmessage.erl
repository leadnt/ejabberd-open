-module(http_send_thirdmessage).

-export([handle/1]).
-include("ejabberd.hrl").
-include("logger.hrl").

handle(Req) ->
    {Method, _} = cowboy_req:method(Req),
    case Method of 
        <<"POST">> ->
            send_message(Req);
        _ ->
            http_utils:cowboy_req_reply_json(http_utils:gen_fail_result(1, <<Method/binary, " is not disable">>), Req)
    end.

send_message(Req)->
    {ok, Body, _} = cowboy_req:body(Req),
    case rfc4627:decode(Body) of
        {ok, {obj,Args},[]} -> 
            From = proplists:get_value("from",Args),
            To = proplists:get_value("to",Args),
            Message = proplists:get_value("message",Args),
            JFrom = jlib:string_to_jid(From),
            JTo = jlib:string_to_jid(To),
            Packet = fxml_stream:parse_element(Message),
            catch monitor_util:monitor_count(<<"rpc_thirdparty_chat_message">>,1),
            catch qtalk_c2s:carbon_message(JFrom, JTo, Packet),
            ejabberd_router:route(JFrom,JTo,Packet),
            http_utils:cowboy_req_reply_json(http_utils:gen_success_result(), Req);
	_ ->
            http_utils:cowboy_req_reply_json(http_utils:gen_fail_result(1, <<"Josn parse error">>), Req)
    end.
