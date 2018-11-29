-module(ejabberd_ldap_sup).

-author('liufannana@sina.com').

-behaviour(gen_mod).
-include("logger.hrl").

-export([start/2,stop/1]).

%% API
-export([start_link/1, init/1]).

-export([add_pid/1, remove_pid/1,
     get_pids/0, get_random_pid/0]).

-export([
		 login/2,
		 get_dep/0]).

-define(SERVER, ?MODULE).
-define(PROCNAME, ?SERVER).

-define(POOLSIZE, 10).

start(Host,Opts) ->
	Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
    Ldap_Hosts = ejabberd_config:get_option(ldap_hosts, fun(A) -> A end, ["test.com"] ),
    Ldap_Port = ejabberd_config:get_option(ldap_port, fun(A) -> A end, 389),
    Ldap_User = ejabberd_config:get_option(ldap_user,   fun(A) -> A end,"username"),
    Ldap_Pass = ejabberd_config:get_option(ldap_pass, fun(A) -> A end,"password"),
	Opts = [{"host", Ldap_Hosts}, {"port",Ldap_Port}, {"user", Ldap_User}, 
		{"passwd", Ldap_Pass}, {"poolsize", 5}],
	start_link(Opts).

stop(Host) ->
        Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
        supervisor:terminate_child(ejabberd_sup, Proc),
        supervisor:delete_child(ejabberd_sup, Proc).

start_link(Option) ->
    ets:new(ldap_server_pid, [named_table, bag, public]),
    catch ets:new(group_info, [bag, named_table, public, {keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
    catch ets:new(pg_user, [bag, named_table, public, {keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
    supervisor:start_link({local,?MODULE}, ?MODULE, [Option]).


init([Option]) ->
	PoolSize = proplists:get_value("poolsize", Option, ?POOLSIZE),
    {ok,
     {{one_for_one, 1000, 1}, lists:map(fun(I) ->
        {I, 
            {ejabberd_ldap_server, start_link, [Option]},
            transient,
            2000,
            worker,
            [?MODULE]} end, lists:seq(1, PoolSize))
	}}.

get_pids() ->
    case ets:tab2list(ldap_server_pid) of
    [] ->
        []; 
    Pids when is_list(Pids) ->
		Pids;
    _ ->
        []
    end.

get_random_pid() ->
    case get_pids() of
      [] -> undefined;
      Pids -> {Pid} = lists:nth(erlang:phash(os:timestamp(), length(Pids)), Pids), Pid
    end.

add_pid(Pid) ->
      ets:insert(ldap_server_pid,{Pid}).

remove_pid(Pid) ->
      ets:delete_object(ldap_server_pid,{Pid}).

login(User, Passwd) ->
	case get_random_pid() of
		undefined ->
			?DEBUG("not ldap info ~p ~n",[self()]),
			 error;
		Pid ->
			ejabberd_ldap_server:login(Pid, User, Passwd)
	end.

get_dep() ->
	case get_random_pid() of
		undefined -> [];
		Pid ->
			ejabberd_ldap_server:get_dep(Pid)
	end.
