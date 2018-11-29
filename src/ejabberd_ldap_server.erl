-module(ejabberd_ldap_server).
-behaviour(gen_server).
-include("logger.hrl").
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

-export([login/3]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {dep = [], handle, user, passwd, hosts, port}).

-define(TIMEOUT, 100).
-define(UPDATEINTERVAL, 60000).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start_link(Opt) ->
    gen_server:start_link(?MODULE, [Opt], []).

login(Server, User, Passwd) ->
	gen_server:call(Server, {login, User, Passwd}).

get_dep(Server) ->
	gen_server:call(Server, get_dep).
%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([Arg]) ->
	User = proplists:get_value("user", Arg, "user"),
	Passwd = proplists:get_value("passwd", Arg, "passwd"),
	Hosts = proplists:get_value("host", Arg, ["test.com"]),
	Port = proplists:get_value("port", Arg, 389),
	State0 = #state{user = User, passwd = Passwd, hosts = Hosts, port = Port}, 
	State = case update_handle(State0) of
    {error, Error} ->
            ?DEBUG("Error ~p ~n",[Error]),
           State0;
    State1 ->
		State1
    end,
	ejabberd_ldap_sup:add_pid(self()),
	{ok, State}.

handle_call(get_dep, _Request, #state{dep = Dep} = State) ->
	{reply, Dep, State};
handle_call({login, User, Passwd}, _Request, State) ->
	case catch simple_bind(User, Passwd, State) of
		{ok, NewState} ->
			{reply, ok, NewState};
		{error, NewState} ->
				 io:format("error ~p ~n",[NewState]),
			{reply, error, NewState}
	end;
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ejabberd_ldap_sup:remove_pid(self()), 
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
get_handle(Hosts, Port) ->
	case eldap:open(Hosts, [{port, Port}, {timeout, ?TIMEOUT}]) of
		{ok, Handle} -> Handle;
		Other -> io:format("get handle error for ~p~n", [Other]), Other
	end.


simple_bind(User, Passwd, #state{handle = undefined, hosts = Hosts, port = Port} = State) ->
	case get_handle(Hosts, Port) of
		{error, _} -> {error, State};
		Handle -> simple_bind(User, Passwd, State#state{handle = Handle})
	end;
simple_bind(User, Passwd, #state{handle = Handle} = State) ->
	case eldap:simple_bind(Handle, User, Passwd) of
		ok -> {ok, State};
		%%the connection may be timeout
		{error, {gen_tcp_error,closed}} ->  io:format("simple_bind time otu ~p ~n",[User]),
						 simple_bind(User, Passwd, State#state{handle = undefined});
		{error, Error} -> io:format("simple_bind error for ~p~n", [Error]), {error, State}
	end.


update_handle(#state{handle = undefined, hosts = Hosts, port = Port} = State) ->
    case get_handle(Hosts, Port) of
        {error, _} = Error -> Error;
        Handle -> State#state{handle = Handle}
    end;
update_handle(#state{handle = Handle, user = User, passwd = Passwd} = State) ->
    State.	
	
