-module(ejabberd_rpc_utils).

-include("ejabberd.hrl").
-include("logger.hrl").

-export([
         call_call/4,
         call/3
        ]).

call_call(Node, M, F, Args) ->
    ?DEBUG("rpc call is called, the params is ~p~n", [{Node, M, F, Args}]),
    rpc:call(Node, M, F, Args).

call(M, F, Args) ->
    ?DEBUG("rpc call is called, the params is [~p:~p(~p)]~n", [M, F, Args]),
    erlang:apply(M, F, Args).
