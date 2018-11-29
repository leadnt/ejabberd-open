%%%----------------------------------------------------------------------
%%%%%% File    : ejabberd_auth_sql.erl
%%%%%% Purpose : auth qtalk key
%%%%%%----------------------------------------------------------------------
%%%

-module(qtalk_auth).

-export([wlan_check_password/3,check_white_list/1,check_frozen_flag/1]).
-export([create_ets_table/0,delete_ets_table/0,kick_token_login_user/2,check_multiple_login_user/1]).
-export([check_user_password/3]).

-include("ejabberd.hrl").
-include("logger.hrl").

%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% 创建删除相关ets表
%%%%%--------------------------------------------------------------------
create_ets_table() ->
    catch ets:new(blacklist, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
    catch ets:new(whitelist, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
    catch ets:new(sn_user,   [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]).

delete_ets_table() ->
    catch ets:delete(blacklist),
    catch ets:delete(whitelist),
    catch ets:delete(sn_user).
        
check_user_password(Host, User, Password) ->
    R = case qtalk_sql:get_password_by_host(Host, User) of
        {selected,_, [[Password1]]} -> 
            case catch rsa:dec(base64:decode(Password)) of
                Json when is_binary(Json) ->
                    {ok,{obj,L},[]} = rfc4627:decode( Json),
                    Pass = proplists:get_value("p",L),
                    Key = proplists:get_value("mk",L),
                    case Key of
                        undefined -> ok;
                    _->
                        NewKey = qtalk_public:concat(User,<<"@">>,Host),
                        catch set_user_mac_key(Host,NewKey,Key)
                    end,
                    do_check_host_user(Host,User,Password1,Pass);
               _ -> false
           end;
        _ -> false
    end,

    if R =:= false -> ?ERROR_MSG("the auth info is ~p~n", [{Host,User,Password}]);
    true -> ok
    end,

    R.

do_check_host_user(Host,User,Password,Pass) ->
   Password =:= Pass. 

%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% WLAN 密码验证
%%%%%--------------------------------------------------------------------

wlan_check_password(Server,User,Pass) ->
    true.

%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% 白名单检查
%%%%%--------------------------------------------------------------------

check_white_list(User) ->
    case ets:lookup(whitelist,User)  of
    [] ->
        false;
    % 只允许单点登录
    [{User, <<"1">>}|_] ->
        {true, single};
     % 允许多个设备同时登录
    _ ->
        {true, no_limit}
    end.


%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% 黑名单检查
%%%%%--------------------------------------------------------------------
check_frozen_flag(User) ->
    case catch ets:lookup(blacklist, User) of
        [] ->
            true;
        _ ->
            false
    end.

%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% WLAN可多登用户
%%%%%--------------------------------------------------------------------
check_multiple_login_user(User) ->
    case catch ets:lookup(multiple_users,User) of
    [{User,1}] ->
        true;
    _ ->
        false
    end.


%%--------------------------------------------------------------------
%%%% @date 2017-03-01
%%%%% 检测用户登陆
%%%%%--------------------------------------------------------------------
check_user_resources(_, _, no_limit) ->
    ok;
check_user_resources(Server, User, single) ->
    case ejabberd_sm:get_user_resources(User, Server) of
        [] ->
            ok;
        Resources ->
            lists:foreach(
              fun(Resource) ->
                      PID = ejabberd_sm:get_session_pid(User, Server, Resource),
                      ?ERROR_MSG("kick user ~p~n", [User]),
                      PID ! kick
              end, Resources)
    end.

kick_token_login_user(Username,Server) ->
    case ejabberd_sm:get_user_present_resources_and_pid(Username, Server) of
    [] ->
        ok;
    Resources ->
        lists:foreach(
            fun({_,Resource,PID}) ->
                case str:str(Resource,<<"Android">>) =:= 0 andalso str:str(Resource,<<"iPhone">>) =:= 0 of
                false ->
                    if is_pid(PID) ->
                        ?ERROR_MSG("kick user ~p~n", [{Username, Resource}]),
                        PID ! kick;
                    true ->
                        ok
                    end;
               true ->
                    ok
                end
            end, Resources)
    end.

set_user_mac_key(Server,User,Key) ->
    UTkey = str:concat(User,<<"_tkey">>),
    case redis_link:redis_cmd(Server,2,["HKEYS",UTkey]) of
    {ok,L} when is_list(L) ->
        case lists:member(Key,L) of
        true ->
            lists:foreach(fun(K) ->
                    catch redis_link:hash_del(Server,2,UTkey,K) end,L -- [Key]);
        _ ->
            lists:foreach(fun(K) ->
                    catch redis_link:hash_del(Server,2,UTkey,K) end,L -- [Key]),
            catch redis_link:hash_set(Server,2,UTkey,Key,qtalk_public:get_timestamp())
        end;
    _ ->
        catch redis_link:hash_set(Server,2,UTkey,Key,qtalk_public:get_timestamp())
    end.

