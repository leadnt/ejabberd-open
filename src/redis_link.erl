-module(redis_link).

-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
                        terminate/2,code_change/3]).


-export([str_set/4,str_get/3,hash_set/5,hash_get/4,hash_del/4,expire_time/4,get_all_keys/2,str_setex/5,str_del/3,ttl_key/3]).
-export([redis_cmd/3,q/3,qp/3,no_time_out_q/3]).

-export([str_set/3,str_get/2,hash_set/4,hash_get/3,hash_del/3,expire_time/3,get_all_keys/1,str_setex/4,str_del/2,ttl_key/2]).
-export([redis_cmd/2,q/2,qp/2,no_time_out_q/2]).

-behaviour(gen_server).

-define(SERVER, ?MODULE).
-include("ejabberd.hrl").
-include("logger.hrl").

-record(state, {host,tab,redis_pid}).

start_link(Host,Tab,Opts) ->
    gen_server:start_link(?MODULE, [Host,Tab,Opts], []).

init([Host,Tab,Opts]) ->
    Redis_Port = gen_mod:get_opt(redis_port, Opts, fun(A) -> A end, 26379),
    Redis_Pass = gen_mod:get_opt(redis_password, Opts, fun(A) -> A end, <<"redis_password">>),
    StartMode = gen_mod:get_opt(redis_start_mode, Opts, fun(A) -> A end, 1),
    Rpid =
        case StartMode  of
        1 ->
            Redis_Master = gen_mod:get_opt(redis_master, Opts, fun(A) -> A end, <<"redis_server">>),
            case eredis:start_link(binary_to_list(Redis_Master),Redis_Port,Tab,binary_to_list(Redis_Pass),1000) of
            {ok,Pid} ->
                ejabberd_redis:add_pid(Host,Tab,self()),
                Pid;
            _ ->
                []
            end;
        _ ->
            Redis_Host = gen_mod:get_opt(redis_server, Opts, fun(A) -> A end, <<"redis_server">>),
            case eredis:start_link(binary_to_list(Redis_Host),Redis_Port,Tab,binary_to_list(Redis_Pass),1000) of
            {ok,Pid} ->
                ejabberd_redis:add_pid(Host,Tab,self()),
                Pid;
            _ ->
                []
            end
        end,
    {ok, #state{host = Host,tab = Tab ,redis_pid = Rpid}}.

handle_call({strget,Key},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["GET",Key],1000),
    {reply,Ret,State};
handle_call({strset,Key,Val},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["SET", Key, Val],1000),
    {reply,Ret,State};
handle_call({ttlkey,Key},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["TTL", Key],1000),
    {reply,Ret,State};
handle_call({strsetex,Key,Time,Val},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["SETEX",Time, Key, Val],1000),
    {reply,Ret,State};
handle_call({expiretime,Key,Time},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["EXPIRE", Key, Time],1000),
    {reply,Ret,State};
handle_call({hashget,Key,Field},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["HGET",Key,Field],1000),
    {reply,Ret,State};
handle_call({hashset,Key,Field,Val},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["HSET", Key, Field,Val],1000),
    {reply,Ret,State};
handle_call(getkeys,_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, ["KEYS", <<"*">>],5000),
    {reply,Ret,State};
handle_call({redis_cmd,Redis_cmd},_From,State) ->
    Ret =  eredis:q(State#state.redis_pid, Redis_cmd,5000),
    {reply,Ret,State};
handle_call({q,Command},_,State) ->
    Ret = eredis:q(State#state.redis_pid, Command),
    {reply,Ret,State};
handle_call({q,Command,Timeout},_,State) ->
    Ret = eredis:q(State#state.redis_pid, Command,Timeout),
    {reply,Ret,State};

handle_call({qp,Pipeline},_,State)  ->
    Ret =  eredis:qp(State#state.redis_pid, Pipeline),
    {reply,Ret,State};
handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

handle_cast({hashdel,Key,Field},State) ->
    case eredis:q(State#state.redis_pid, ["HDEL", Key, Field]) of
    {error,Reason} ->
        ?DEBUG("Run redis error ~p ~n",[Reason]);
    _ ->
        ok
    end,
    {noreply,State};
handle_cast({strdel,Key},State) ->
    case eredis:q(State#state.redis_pid, ["DEL", Key]) of
    {error,Reason} ->
        ?DEBUG("Run redis error ~p ~n",[Reason]);
    _ ->
        ok
    end,
    {noreply,State};
handle_cast(stop, State) ->
    catch ejabberd_redis:remove_pid(State#state.host,State#state.tab,self()),
    {stop, normal, State}.

handle_info(_From,State) ->
    {noreply,State}.

terminate(_Reason, State) ->
    catch ejabberd_redis:remove_pid(State#state.host,State#state.tab,self()),
    {ok,State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

expire_time(Tab,Key,Time) ->
	expire_time(?SERVER_KEY,Tab,Key,Time).
expire_time(Host,Tab,Key,Time) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid, {expiretime,Key,Time},Host,Tab).

str_set(Tab,Key,Str) ->
	str_set(?SERVER_KEY,Tab,Key,Str).

str_set(Host,Tab,Key,Str) ->
   Rpid = ejabberd_redis:get_random_pid(Host,Tab),
   do_call(Rpid, {strset,Key,Str},Host,Tab).

str_setex(Tab,Time,Key,Str) ->
	str_setex(?SERVER_KEY,Tab,Time,Key,Str).

str_setex(Host,Tab,Time,Key,Str) ->
   Rpid = ejabberd_redis:get_random_pid(Host,Tab),
   do_call(Rpid, {strsetex,Key,Time,Str},Host,Tab).

str_get(Tab,Key) ->
	str_get(?SERVER_KEY,Tab,Key) .

str_get(Host,Tab,Key) ->
   Rpid = ejabberd_redis:get_random_pid(Host,Tab),
   do_call(Rpid,{strget,Key},Host,Tab).

hash_set(Tab,Key,Field,Val) ->
	hash_set(?SERVER_KEY,Tab,Key,Field,Val).

hash_set(Host,Tab,Key,Field,Val) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid, {hashset,Key,Field,Val},Host,Tab).

hash_get(Tab,Key,Field) ->
	hash_get(?SERVER_KEY,Tab,Key,Field).

hash_get(Host,Tab,Key,Field) ->
   Rpid = ejabberd_redis:get_random_pid(Host,Tab),
   do_call(Rpid,{hashget,Key,Field},Host,Tab).

hash_del(Tab,Key,Field) ->
	hash_del(?SERVER_KEY,Tab,Key,Field).

hash_del(Host,Tab,Key,Field) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_cast(Rpid, {hashdel,Key,Field}).

str_del(Tab,Key) ->
	str_del(?SERVER_KEY,Tab,Key).
str_del(Host,Tab,Key) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_cast(Rpid, {strdel,Key}).

get_all_keys(Tab) ->
	get_all_keys(?SERVER_KEY,Tab).

get_all_keys(Host,Tab) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid,getkeys,Host,Tab).

ttl_key(Tab,Key) ->
	ttl_key(?SERVER_KEY,Tab,Key).
ttl_key(Host,Tab,Key) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid, {ttlkey,Key},Host,Tab).

redis_cmd(Tab,Cmd) ->
	redis_cmd(?SERVER_KEY,Tab,Cmd).

redis_cmd(Host,Tab,Cmd) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid, {redis_cmd,Cmd},Host,Tab).

q(Tab,Cmd) ->
	q(?SERVER_KEY,Tab,Cmd).
q(Host,Tab,Cmd) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid,{q,Cmd},Host,Tab).

qp(Tab,Pipeline) ->	
	qp(?SERVER_KEY,Tab,Pipeline).
qp(Host,Tab,Pipeline) ->	
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    do_call(Rpid,{qp,Pipeline},Host,Tab).

do_call(Pid, Message,Host,Tab) when is_pid(Pid) ->
    case catch erlang:process_info(Pid,message_queue_len) of
    {message_queue_len,N} when is_integer(N) andalso N < 10000 ->
    	case catch  gen_server:call(Pid, Message) of
	    L when is_list(L) ->
		L;
	    {error, Error} ->
		?INFO_MSG("Lost Pid Message ~p ~n",[Message]),
	        {error, Error};
	    {ok, Reply} ->
        	{ok, Reply}; 
	   {'EXIT',{noproc,_ }} ->
		?INFO_MSG("Lost Pid Message ~p ~n",[Message]),
		check_redis_pid_alive(Host,Tab,Pid);
	   Error ->
		?INFO_MSG("Lost Pid Message ~p ~p~n",[Message, Error]),
       		{error, <<"unknown error">>}
	    end;
    undefined ->
        ?INFO_MSG("catch crash pid ~p ~n",[Pid]),
	    ejabberd_redis:remove_pid(Host,Tab,Pid),
        supervisor:terminate_child(ejabberd_redis,Pid);
    _ ->
       	?INFO_MSG("redis queue is full ,abdon this Message ~p ~n",[Message])
    end;
do_call(Pid, _Message,Host,Tab)  ->
  ?INFO_MSG("get Error Pid ~p ~n",[Pid]),
   catch ets:delete_object(redis_pid,{Host,Tab,Pid}).	
	

do_cast(Pid,Message) when is_pid(Pid)  ->
    case catch erlang:process_info(Pid,message_queue_len) of
    {message_queue_len,N} when is_integer(N) andalso N < 10000 ->
    	try gen_server:cast(Pid, Message) of
	    {error, Error} ->
        	{error, Error};
	    ok ->
	        ok
	    catch
        	_Type:Error ->
	            {error, Error}
	    end;
    _ ->
	?INFO_MSG("redis queue is full ,abdon this Message ~p ~n",[Message])
    end;
do_cast(Pid,Message) ->
    ?INFO_MSG("get Error Pid ~p ~p~n",[Pid, Message]),
    ok.


check_redis_pid_alive(Host,Tab,Pid) ->
    case catch erlang:process_info(Pid) of
    undefined ->
	    ejabberd_redis:remove_pid(Host,Tab,Pid),
        supervisor:terminate_child(ejabberd_redis,Pid),
        false;
    _ ->
    	?INFO_MSG("Redis pid error ~p ~n",[Pid]),
        true
    end.


no_time_out_q(Tab,Cmd) ->
	no_time_out_q(?SERVER_KEY,Tab,Cmd) .
no_time_out_q(Host,Tab,Cmd) ->
    Rpid = ejabberd_redis:get_random_pid(Host,Tab),
    no_time_out_call(Rpid,{q,Cmd,50000},Host,Tab).


no_time_out_call(Pid, Message,Host,Tab) when is_pid(Pid) ->
    case catch erlang:process_info(Pid,message_queue_len) of
    {message_queue_len,N} when is_integer(N) andalso N < 10000 ->
        case catch  gen_server:call(Pid, Message,infinity) of
        L when is_list(L) -> L;
        {error, Error} -> {error, Error};
        {ok, Reply} -> {ok, Reply};
        {'EXIT',{noproc,_ }} ->
            ?INFO_MSG("Lost Pid Message ~p ~n",[Message]),
            check_redis_pid_alive(Host,Tab,Pid);
        Error ->
            ?INFO_MSG("Lost Pid Message ~p ~p~n",[Message, Error]),
            {error, <<"unknown error">>}
        end;
    _ -> ?INFO_MSG("redis queue is full ,abdon this Message ~p ~n",[Message])
    end;
no_time_out_call(Pid, _Message,Host,Tab)  ->
   ?INFO_MSG("get Error Pid ~p ~n",[Pid]),
   catch ets:delete_object(redis_pid,{Host,Tab,Pid}).
        
