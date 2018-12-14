-module(http_dispatch).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).
-include("ejabberd.hrl").
-include("logger.hrl").

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {Path, _} = cowboy_req:path_info(Req),
    Req1 = handle_process(Path, Req),
    {ok, Req1, State}.

terminate(_Reason, _Req, _State) ->
    ok.

handle_process([<<"send_thirdmessage">>], Req) ->
    http_send_thirdmessage:handle(Req);
handle_process([<<"create_muc">>], Req) ->
    http_muc_create:handle(Req);
handle_process([<<"add_muc_user">>], Req) ->
    http_muc_add_user:handle(Req);
handle_process([<<"del_muc_user">>], Req) ->
    http_muc_del_user:handle(Req);
handle_process([<<"destroy_muc">>], Req) ->
    http_muc_destroy:handle(Req);
handle_process(_, Req) ->
    http_utils:cowboy_req_reply_json(http_utils:gen_fail_result(1, <<"request not defined">>), Req).
