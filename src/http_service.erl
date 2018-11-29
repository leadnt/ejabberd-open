-module(http_service).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
		                terminate/2,code_change/3]).

-export([start/2]).
-export([stop/1]).

-behaviour(gen_server).

-include("ejabberd.hrl").
-include("logger.hrl").

-record(state, {info}).

start_link(Info) ->
    gen_server:start_link(?MODULE, [Info], [Info]).

init([Info]) ->
	{ok, #state{info = Info}, 0}.

handle_call(Msg, _From, State) ->
    {reply, {ok, Msg}, State}.

handle_cast(stop, State) ->
    {stop, normal, State}.

handle_info(timeout,State =  #state{info = Opts} ) ->
	start(<<"">>,Opts),
	{noreply,State}.

terminate(_Reason, State) ->
	{ok,State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

start(_Type, Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
                        {"/qtalk/[...]", http_dispatch, []},
			{"/sendmessage",http_sendmessage,[]},
			{"/send_warn_msg",http_send_warn_msg,[]},
			{"/sendnotice",http_sendall,[]},
			{"/management_cmd",http_management,[]},
			{"/qmonitor.jsp",http_qmonitor,[]},
			{"/send_rbt_msg",http_send_rbt_msg,[]},
			{"/wlan_send_msg",http_wlan_send_msg,[]},
			{"/get_user_status",http_get_user_status,[]},
			{"/send_muc_presence",http_muc_vcard_presence,[]},
			{"/create_muc",http_create_muc,[]},
			{"/add_muc_user",http_add_muc_user,[]},
			{"/del_muc_user",http_del_muc_user,[]},
			{"/destroy_muc",http_destroy_muc,[]},
			{"/get_muc_info",http_get_muc_info,[]},
            {"/reload_module", http_reload_module, []},
            {"/registeruser", http_registeruser, []}
		]}
	]),
	cowboy:stop_listener(http),
    Http_port = gen_mod:get_opt(http_port, Args, fun(A) -> A end, 10050),
	{ok,_} = cowboy:start_http(http, 200, [{port,Http_port}], [
		{env, [{dispatch, Dispatch},{max_connections, infinity}]}
	]).

stop(_State) ->
	ok.
