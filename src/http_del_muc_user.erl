%% Feel free to use, reuse and abuse the code in this file.

-module(http_del_muc_user).
-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-export([del_muc_users/2]).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
	{Method, _} = cowboy_req:method(Req),
	case Method of 
	<<"GET">> ->
		{ok, Req1} = echo(<<"No Get Method!">>,Req),
		{ok, Req1, State};
	<<"POST">> ->
		HasBody = cowboy_req:has_body(Req),
		{ok, Req1} = post_echo(Method, HasBody, Req),
		{ok, Req1, State};
	_ ->
		{ok,Req1} = echo(undefined, Req),
		{ok, Req1, State}
	end.
post_echo(<<"POST">>,true,Req) ->	
	{ok, PBody, _} = cowboy_req:body(Req),
	Header = cowboy_req:get(headers,Req),
	{Type,_ } = cowboy_req:qs_val(<<"type">>, Req),
	Body = 
		case catch proplists:get_value(<<"content-encoding">>,Header) of 
		<<"gzip">> ->
			zlib:gunzip(PBody);
		_ ->
			PBody
		end,	
	case rfc4627:decode(Body) of
	{ok,{obj,Args},[]}  ->
		Res = del_muc_users(Type,Args),
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

del_muc_users(Type,Args) ->
	Servers = ejabberd_config:get_myhosts(),
	LServer = lists:nth(1,Servers),
	case Type of 
   	<<"1">>	 ->
		do_del_muc_users(LServer,Args);
	_ ->
		do_del_muc_users(LServer,Args)
	end.

do_del_muc_users(Server,Args) ->
	Muc_id = 		http_muc_session:get_value("muc_id",Args,<<"">>),
	Muc_owner =		http_muc_session:get_value("muc_owner",Args,<<"">>),
	Host  =			http_muc_session:get_value("muc_owner_host",Args,Server),
	Muc_member =		http_muc_session:get_value("muc_member",Args,<<"">>),
	Domain =		http_muc_session:get_value("muc_domain",Args,<<"">>),
    Muc_Towner =        http_muc_session:get_value("muc_true_owner",Args,Muc_owner),
	Owner = jlib:jid_to_string({Muc_Towner,Host,<<"">>}),
    case mod_muc:check_muc_owner(Server,Muc_id,Owner) of
    true ->
        case jlib:make_jid(Muc_id,Domain,<<"">>) of
        error ->
	        ok;
        To ->
            Packet = http_muc_session:make_del_register_muc_iq(),
            lists:foreach(fun(U) ->
                From = jlib:make_jid(U,Server,<<"">>),
                catch ejabberd_router:route(From,To,Packet) end ,Muc_member)
       	end,
        http_utils:gen_result(true, <<"0">>,<<"">>,<<"sucess">>);
    _ ->
        http_utils:gen_result(false, <<"1">>,<<"owner error">>,<<"failed">>)
    end.

