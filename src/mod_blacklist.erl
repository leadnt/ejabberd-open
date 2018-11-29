-module(mod_blacklist).

-behaviour(gen_mod).
-behaviour(gen_server).

-define(SERVER, ?MODULE).
-define(SUPERVISOR, ejabberd_sup).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/2]).

%% gen_mod callbacks
-export([start/2, stop/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-export([is_forbid/1]).

-record(state, {server}).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start(Host, Opts) ->
    Proc = gen_mod:get_module_proc(Host, ?MODULE),
    PingSpec = {Proc, {?MODULE, start_link, [Host, Opts]},
		transient, 2000, worker, [?MODULE]},
    supervisor:start_child(?SUPERVISOR, PingSpec).

stop(Host) ->
    Proc = gen_mod:get_module_proc(Host, ?MODULE),
    gen_server:call(?SERVER, stop),
    supervisor:delete_child(?SUPERVISOR, Proc).

start_link(Host, Opts) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [Host, Opts], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([Host, Opts]) ->
    create_ets_table(),
    erlang:send_after(10 * 1000, self(), update_cache),
    {ok, #state{server = Host}, 0}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(timeout, State = #state{server = Server}) ->
    update_cache(Server),
    {noreply, State};
handle_info(update_cache, State = #state{server = Server}) ->
    update_cache(Server),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


is_forbid(Username) ->
    case ets:lookup(blacklist_cache, Username) of
        [{Username, <<"1">>}|_] ->
            true;
        _ ->
            false
    end.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

create_ets_table() ->
    catch ets:new(blacklist_cache, [named_table, duplicate_bag, public,{keypos, 1},{write_concurrency, true}, {read_concurrency, true}]).

update_cache(Server) ->
    ets:delete_all_objects(blacklist_cache),
    case catch ejabberd_sql:sql_query(Server, [<<"select username, flag from blacklist">>]) of
        {selected, _, Res} ->
            lists:foreach(fun([Username, Flag]) ->
                                  ets:insert(blacklist_cache, {Username, Flag})
                          end, Res),
            erlang:send_after(10 * 1000, self(), update_cache);
        Error ->
            ?ERROR_MSG("Get a Unknown error for update blacklist cache: ~p~n", [Error]),
            erlang:send_after(5 * 1000, self(), update_cache)
    end.
