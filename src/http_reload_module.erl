%% Feel free to use, reuse and abuse the code in this file.
-module(http_reload_module).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-export([reload_module/1]).


-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").


init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, _ } = cowboy_req:method(Req),
	case Method of 
	<<"GET">> ->
		{ok, Req1} = echo(<<"No Get Method!">>,Req),
		{ok, Req1, State};
	<<"POST">> ->
		HasBody = cowboy_req:has_body(Req),
		{ok, Req2} = post_echo(Method, HasBody, Req),
		{ok, Req2, State};
	_ ->
		{ok,Req3} = echo(undefined, Req),
		{ok, Req3, State}
	end.

post_echo(<<"POST">>,true,Req) ->	
	{ok, Body, _} = cowboy_req:body(Req),
	case rfc4627:decode(Body) of
    {ok,L,[]} ->    
        Res = reload_module(L),
		cowboy_req:reply(200, [{<<"content-type">>, <<"text/json; charset=utf-8">>}], Res, Req);
	_ ->
		cowboy_req:reply(200, [{<<"content-type">>, <<"text/json; charset=utf-8">>}], 
					http_utils:gen_result(false, <<"-1">>,<<"Json format error.">>,<<"">>), Req)
	end;
post_echo(<<"POST">>, false, Req) ->
	cowboy_req:reply(400, [], http_utils:gen_result(false, <<"-1">>,<<"Missing Post body.">>,<<"">>), Req);
post_echo(_, _, Req) ->
	cowboy_req:reply(405, Req).
										

echo(undefined, Req) ->
	cowboy_req:reply(400, [], http_utils:gen_result(false, <<"-1">>,<<"Missing Post body.">>,<<"">>), Req);
echo(Echo, Req) ->
    cowboy_req:reply(200, [
			        {<<"content-type">>, <<"text/plain; charset=utf-8">>}
	    			    ], http_utils:gen_result(true, <<"0">>,Echo,<<"">>), Req).

terminate(_Reason, _Req, _State) ->
	ok.

reload_module(L) when is_list(L) ->
   R = lists:flatmap(fun(M) ->
        Module = list_to_atom(binary_to_list(M)),
        code:soft_purge(Module),
        case code:load_file(Module) of
            {module, _} -> [{M,<<"success">>}];
            _ -> [{M,<<"failed">>}]
        end end ,L),
    http_utils:gen_result(true, 0,<<"">>,  {obj,R});
reload_module(_) ->
    http_utils:gen_result(false, 1,<<"">>, <<"reload module failed">>).
