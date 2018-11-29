-module(monitor_util).

-export([monitor_count/2]).

-include("ejabberd.hrl").
-include("logger.hrl").

monitor_count(Key, Value) ->
    ?DEBUG("this is reload test~n", []),
    catch mod_static:add_record(Key, Value).
