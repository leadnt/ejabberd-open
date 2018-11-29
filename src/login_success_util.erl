-module(login_success_util).
 
-export([do_process/1,
		 close_stat/4
		]).
 
-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").
 
do_process(User) ->
    ?INFO_MSG("the login success user is ~p~n", [User]).

close_stat(User, Resource, IP, Time) ->
    close_stat(User, Resource, IP, Time, ?PLATFORM).

close_stat(User, Resource, {IP, _}, {{MegaSecs, Secs, _}, _}, qchat) when User =/= [], Resource =/= <<"">> ->
	Ip = inet_parse:ntoa(IP),
	Timestamp = qtalk_public:format_time(MegaSecs * 1000000 + Secs),
	case whereis('mod_pg_odbc') of
	Pid when is_pid(Pid) ->
		catch pg_odbc:sql_query(<<"pg2">>,	
			[<<"insert into login_data (username, platform, ip, login_time) values ('">>, User,<<"','">>, 
				Resource, <<"', '">>, Ip, <<"', '">>, Timestamp, <<"');">>]);
	_ ->
		catch ejabberd_sql:sql_query(?LSERVER, 
			[<<"insert into login_data (username, platform, ip, login_time) values ('">>, User,<<"','">>, 
				Resource, <<"', '">>, Ip, <<"', '">>, Timestamp, <<"');">>])
	end;
close_stat(_, _, _, _,_) ->
    ok.
