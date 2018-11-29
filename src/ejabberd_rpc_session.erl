-module(ejabberd_rpc_session).

-include("ejabberd.hrl").
-include("logger.hrl").

-export([
         get_users_status/1,
         get_users_flag/1,
         get_online_users_status/1,
         get_user_status/1,
         get_user_status/2
        ]).

get_users_status(Users) ->
    lists:map(fun(X) ->
                  {X, get_user_status(X)}
              end, Users).

get_users_flag(Users) ->
    lists:map(fun(X) ->
                  {X, get_user_flag(X)}
              end, Users).

get_online_users_status(Users) ->
    lists:foldl(fun(X, Acc) ->
                  case get_user_status(X) of
                      <<"offline">> ->
                          Acc;
                      Flag ->
                          [{X, Flag}|Acc]
                  end 
                end, [], Users).

get_user_status(User) ->
    case ejabberd_sm:get_user_online_status(User, ?LSERVER) of
        [] ->
            <<"offline">>;
        Flags ->
            get_max_status(Flags)
    end.

get_user_status(User, Server) ->
    case ejabberd_sm:get_user_online_status(User, Server) of
        [] ->
            <<"offline">>;
        Flags ->
            get_max_status(Flags)
    end.

get_user_flag(User) ->
    case ejabberd_sm:get_user_online_flag(User, ?LSERVER) of
        [] ->
            {<<"offline">>, <<"">>};
        Flags ->
            get_max_flag(Flags)
    end.

get_max_status(Flags) ->
    F = lists:foldl(fun(Flag, M) ->
                    IFlag = ejabberd_sm:flag_to_integer(Flag),
                    IM = ejabberd_sm:flag_to_integer(M),
                    if IFlag > IM ->
                        Flag;
                       true ->
                        M
                    end
                end, <<"offline">>, Flags),
	case F of
		<<"push">> -> <<"online">>;
		_ -> F
	end.

get_max_flag(Flags) ->
	{F, R} = lists:foldl(fun({Flag, R} = O1, {M, R1} = O2) ->
                    IFlag = ejabberd_sm:flag_to_integer(Flag),
                    IM = ejabberd_sm:flag_to_integer(M),
                    if IFlag > IM ->
                        O1;
                       true ->
                        O2
                    end
                end, {<<"offline">>, <<"">>}, Flags),
	case {F, R} of
		{<<"push">>, _} -> {<<"online">>, R};
		_ -> {F, R}
	end.
