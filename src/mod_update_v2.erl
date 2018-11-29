-module(mod_update_v2).

-behaviour(gen_server).
-behaviour(gen_mod).

-export([start/2,stop/1,start_link/1,init/1]).

-export([handle_call/3, handle_cast/2,
 	    handle_info/2, terminate/2, code_change/3]).

-export([update_whitelist/1,update_blacklist/1]).
-export([update_user_mask/4,del_user_mask/4,get_user_vcard_version/1,update_virtual_users/1]).
-export([update_black_version/1,update_flogin_list/1]).
-export([depends/2, mod_opt_type/1]).
-export([update_user_mask_redis/4,del_user_mask_redis/4]).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("qtalk.hrl").
-record(state, {lv1_tref,lv2_tref,lv3_tref, server}).

-define(SERVER, ?MODULE).
-define(PROCNAME, ?SERVER).

start(Host,Opts) ->
     Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
     ChildSpec = {Proc,{?MODULE, start_link, [{Host,Opts}]}, permanent, infinity,worker,[Proc]},
     {ok,_Pid} = supervisor:start_child(ejabberd_sup, ChildSpec).

stop(Host) ->
    qtalk_ets_table:stop_ets_table(),
    Proc = gen_mod:get_module_proc(Host, ?PROCNAME),
    supervisor:terminate_child(ejabberd_sup, Proc),
    supervisor:delete_child(ejabberd_sup, Proc).

start_link({Server,Opts}) ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [{Server,Opts}], []).

init([{Server,Opts}]) ->
    create_ets_table(),
    _Time = get_update_time(Opts),
    Lv1_Tref = erlang:start_timer(7200*1000, self(), lv1),
    Lv2_Tref = erlang:start_timer(3600*1000, self(), lv2),
    Lv3_Tref = erlang:start_timer(600*1000,  self(), lv3),
    {ok, #state{lv1_tref = Lv1_Tref,
                   server = Server, lv2_tref = Lv2_Tref, lv3_tref = Lv3_Tref},0}.

handle_call(stop, _From, State=#state{lv1_tref = Lv1_Tref, lv2_tref = Lv2_Tref, lv3_tref = Lv3_Tref}) ->
    {ok, cancel} = erlang:cancel_timer(Lv3_Tref),
    {ok, cancel} = erlang:cancel_timer(Lv2_Tref),
    {ok, cancel} = erlang:cancel_timer(Lv1_Tref),
    {stop, normal, stopped, State};
handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast({update_virtual_session,Session},State) ->
    catch spawn(mod_extend_iq, update_virtual_session,[Session]),
    ?DEBUG("start Session ~p ~n",[Session]),
    {noreply, State};
handle_cast({delete_virtual_session,From,To},State) ->
    catch spawn(mod_extend_iq, end_virtual_session,[From,To]),
    ?DEBUG("end Session ~p , ~p ~n",[From,To]),
    {noreply, State};
handle_cast({delete_virtual_sessions,Key},State) ->
    catch spawn(mod_extend_iq, end_virtual_sessions,[Key]),
    ?DEBUG("end Session list ~p ~n",[Key]),
    {noreply, State};
handle_cast({update_virtual_user,Virtual_user},State) ->
    catch spawn(?MODULE,update_virtual_user,[State#state.server,Virtual_user,true]),
    {noreply, State};
handle_cast(_Msg, State) ->    
    {noreply, State}.

handle_info(timeout, State=#state{server = Server}) ->
    catch ejabberd_s2s:update_s2s_mapperd_host(Server),
    lv1_update_info(Server),
    lv2_update_info(Server),
    lv3_update_info(Server),
    update_multiple_users(Server),

    {noreply, State};
handle_info({timeout, _Ref, lv1}, State=#state{server = Server}) ->
    lv1_update_info(Server),
    Lv1_Tref = erlang:start_timer(7200*1000,self(), lv1),
    Tref = check_timer_tref(Lv1_Tref,7200*1000,lv1), 
    {noreply, State#state{lv1_tref = Tref}};
handle_info({timeout, _Ref, lv2}, State=#state{server = Server}) ->
    lv2_update_info(Server),
   %% catch spawn(mod_extend_iq,handle_outdate_virtual_session,[State#state.server]),
    Lv2_Tref = erlang:start_timer(3600*1000,self(), lv2),
    Tref = check_timer_tref(Lv2_Tref,3600*1000,lv2), 
    {noreply, State#state{lv2_tref = Tref}};
handle_info({timeout, _Ref, lv3}, State=#state{server = Server}) ->
    lv3_update_info(Server),
    catch spawn(mod_extend_iq,handle_outdate_virtual_session,[State#state.server]),
    Lv3_Tref = erlang:start_timer(600*1000,self(), lv3),
    Tref = check_timer_tref(Lv3_Tref,600*1000,lv3), 
    ?DEBUG("Run lv3 Tref ~p ~n",[self()]),
    update_virtual_users_v2(Server),
	update_flogin_list(Server),
    {noreply, State#state{lv3_tref = Tref}};
handle_info(update_user_info,State=#state{server = LServer}) ->
    mod_day_check:clear_muc_users_dimission(LServer),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

check_timer_tref(Ref,Time,Key) ->
    case erlang:read_timer(Ref) of
        false -> erlang:start_timer(Time,self(), Key);
        _ -> Ref
    end.

lv1_update_info(Server) ->
    update_department_pgsql(Server),
    update_user_list(Server),
    update_user_sn(Server),
    update_virtual_users(Server),
    update_user_mask_list(Server).

lv2_update_info(Server) ->
    update_department_pgsql(Server),
    update_whitelist(Server),
    update_blacklist(Server),
    update_vcard_version(Server),
 %   update_flogin_list(Server),
    subscription:update_subscription_info(Server),
    subscription:update_user_robots(Server).

lv3_update_info(Server) ->
    update_mac_push_notice(Server).


update_multiple_users(_LServer) ->
    ok.

update_nlimit_mask_user(Server) ->
    catch ets:insert(nlimit_mask_user,{<<"it-rexian">>,1}).


update_department_pgsql(LServer) ->
     case catch qtalk_sql:get_host_info(LServer) of
     {selected,_,Res} when is_list(Res) ->
	catch ets:delete_all_objects(host_info),
	lists:foreach(fun([HID,Host]) ->
		catch ets:insert(host_info,{HID,Host}) end,Res);
	_ ->
		ok
	end,
     case catch qtalk_sql:get_department_info1(jlib:nameprep(LServer)) of
         {selected,_,SRes} when is_list(SRes) ->
             catch ets:delete_all_objects(nicks),
             catch ets:delete_all_objects(nick_name),
             catch ets:delete_all_objects(department_users),
             lists:foreach(fun([Hid,D1,D2,D3,D4,D5,J,N,_D,_Sp]) -> 
		        HostName = case catch ets:lookup(host_info,Hid) of
			    [{_,Host1}] ->
					Host1;
			    _ ->
					Hid
			    end,
                 catch ets:insert(department_users,#department_users{dep1 = HostName,user = J}),
                 catch ets:insert(nick_name,{{N,HostName},J}),
                 catch ets:insert(nicks,{{J,HostName},N})
             end,SRes);
          _ -> []
      end.

get_update_time(Opts) ->
    gen_mod:get_opt(update_time_interval,
                    Opts,
                    fun(A) -> A end,
                    500000).

create_ets_table() ->
    qtalk_ets_table:create_ets_table().

update_blacklist(LServer) ->
    ets:delete_all_objects(blacklist),
    case catch qtalk_sql:get_blacklist(jlib:nameprep(LServer)) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([Username]) ->
                ets:insert(blacklist,{Username})
            end, SRes);
        Error -> ?DEBUG("Get blacklist error for ~p ~n",[Error])
    end.
    
update_mac_push_notice(LServer) ->
    ets:delete_all_objects(mac_push_notice),
    case catch ejabberd_sql:sql_query(jlib:nameprep(LServer), [<<"select user_name,shield_user  from mac_push_notice ;">>]) of
        {selected,[<<"user_name">>,<<"shield_user">>],SRes} when is_list(SRes) ->
            lists:foreach(fun([User,Shield]) ->
                ets:insert(mac_push_notice,#mac_push_notice{user = {User,Shield}})
            end,SRes);
        Error -> ?DEBUG("Get blacklist error for ~p ~n",[Error])
    end.

update_user_list(LServer) ->
    ets:delete_all_objects(userlist),
    case catch sql_queries:list_users(jlib:nameprep(LServer)) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([Username]) ->
                ets:insert(userlist,{Username})
            end,SRes);
        Error -> ?DEBUG("Get userlist error for ~p ~n",[Error])
    end.

update_whitelist(LServer) ->
    ets:delete_all_objects(whitelist),
    case catch qtalk_sql:get_white_list_users(jlib:nameprep(LServer)) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([Username, SingleFlag]) ->
                ets:insert(whitelist,{Username, SingleFlag})
            end,SRes);
        Error -> ?DEBUG("Get whitelist error for ~p ~n",[Error])
    end.

update_flogin_list(LServer) ->
    ets:delete_all_objects(flogin_list),
    case catch qtalk_sql:get_flogin_user(jlib:nameprep(LServer)) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([Username]) ->
                ets:insert(flogin_list,{Username})
            end,SRes);
        Error -> ?DEBUG("Get flogin_list error for ~p ~n",[Error])
    end.

update_user_sn(LServer) ->
    ets:delete_all_objects(sn_user),
    case catch ejabberd_sql:sql_query(LServer,[<<"select sn,hire_type from users where hire_flag > 0;">>]) of
        {selected, [<<"sn">>,<<"hire_type">>], SRes} when is_list(SRes) ->
            lists:foreach(fun([Sn,Hire_type]) ->
                case Hire_type =/= <<"实习生（地推）"/utf8>> andalso Hire_type =/= <<"实习（HC）"/utf8>> andalso Hire_type =/= <<"外包"/utf8>> of 
                    true -> ets:insert(sn_user,{Sn,Hire_type});
                    _ -> ok
                end
            end,SRes);
        _ -> ok
    end.

update_black_version(Server) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select version from black_version;">>]) of
        {selected, [<<"version">>],Res}  when is_list(Res) ->
            ets:delete_all_objects(black_version),
            lists:foreach(fun(V) ->
                ets:insert(black_version,{V,1})
            end, Res);
        _ -> ok
    end.

update_user_mask_list(Server) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select user_name,masked_user from mask_users;">>]) of
        {selected, [<<"user_name">>,<<"masked_user">>], SRes} when is_list(SRes) ->
            catch ets:delete_all_objects(user_mask_list),
            catch ets:delete_all_objects(shield_user),
            lists:foreach(fun([U,M]) ->
                update_user_mask(Server,U,M,false)
           %     update_user_mask_redis(Server,U,M,false)
            end,SRes);
        _ -> ok
    end.

update_user_mask(Server,User,Mask,Sql_flag) ->
    case catch ets:lookup(user_mask_list,User) of
        [] ->
            case Sql_flag of
                true -> catch ejabberd_sql:sql_query(Server, [<<"insert into mask_users(user_name,masked_user) values ('">>,User,<<"','">>,Mask,<<"');">>]);
                _ -> ok
            end,
            catch ets:insert(user_mask_list,{User,[Mask]}),
            catch ets:insert(shield_user,{list_to_binary(lists:sort([User,Mask])),1});
        [{User,L}] ->
            case catch lists:member(Mask,L) of
                false ->
                    case Sql_flag of
                        true -> catch ejabberd_sql:sql_query(Server, [<<"insert into mask_users(user_name,masked_user) values ('">>,User,<<"','">>,Mask,<<"');">>]);
                        _ -> ok
                    end,
                    catch ets:insert(user_mask_list,{User,[Mask] ++ L}),
                    catch ets:insert(shield_user,{list_to_binary(lists:sort([User,Mask])),1});
                true -> ok
            end;
        _ ->
            false
    end.

update_user_mask_redis(Server,User,Mask,Sql_flag) ->
    Ukey = qtalk_public:user_to_mask_key(User),
    MKey = qtalk_public:user_to_mask_key(Mask),
    case catch redis_link:hash_get(Server,3,User,<<"mask_user">>) of
    {ok,undefined} -> 
        catch redis_link:hash_set(Server,3,User,<<"mask_user">>,[Mask]),
        case Sql_flag of
        true -> catch ejabberd_sql:sql_query(Server, [<<"insert into mask_users(user_name,masked_user) values ('">>,User,<<"','">>,Mask,<<"');">>]);
        _ -> ok
        end;
    {ok,L } when is_list(L) ->
        case catch lists:member(Mask,L) of
        false ->
            case Sql_flag of
            true -> catch ejabberd_sql:sql_query(Server, [<<"insert into mask_users(user_name,masked_user) values ('">>,User,<<"','">>,Mask,<<"');">>]);
             _ -> ok
            end,
            catch redis_link:hash_set(Server,3,User,<<"mask_user">>,[Mask]++L);
        true ->
            ok;
        Err ->
            ?DEBUG("error ~p ~n",[Err])
        end;
    _ ->
        false
    end.
             
del_user_mask_redis(Server,User,Mask,Sql_flag) ->
    case catch redis_link:hash_get(Server,3,User,<<"mask_user">>) of
    {ok,L } when is_list(L) ->
        case catch lists:member(Mask,L) of
        true ->
           catch redis_link:hash_set(Server,3,User,<<"mask_user">>,L -- [Mask]),
           case Sql_flag of
           true ->
                catch ejabberd_sql:sql_query(Server, [<<"delete from mask_users where user_name = '">>,User,<<"' and masked_user = '">>,Mask,<<"';">>]);
                 _ -> ok
           end;
        _ ->
            ok
        end;
    _ ->
        ok
    end.
            
del_user_mask(Server,User,Mask,Sql_flag) ->
    case catch ets:lookup(user_mask_list,User) of
        [] -> ok;
        [{User,L}] ->
            case catch lists:member(Mask,L) of
                true ->
                    case Sql_flag of
                        true ->
                            catch ejabberd_sql:sql_query(Server, [<<"delete from mask_users where user_name = '">>,User,<<"' and masked_user = '">>,Mask,<<"';">>]);
                        _ -> ok
                    end,
                    NewUL = L -- [Mask],
                    case NewUL of
                        [] -> ets:delete(user_mask_list,User);
                        _ -> ets:insert(user_mask_list, {User,NewUL})
                    end,
                    del_ets_shield_user(User,Mask);
                _ -> ok
            end;
        _ -> ok
    end.

del_ets_shield_user(User,Mask) ->
    case catch ets:lookup(user_mask_list,Mask) of    
        [] -> catch ets:delete(shield_user,list_to_binary(lists:sort([User,Mask])));
        [{Mask,L}] when is_list(L) ->
            case catch lists:member(User,L) of
                false -> catch ets:delete(shield_user,list_to_binary(lists:sort([User,Mask])));
                _ -> ok
            end;
        _ -> ok
    end.

update_vcard_version(Server) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select username,version,url from vcard_version;">>]) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([U,V,L]) ->
                ets:insert(vcard_version,#vcard_version{user = U,version = V,url = L})
            end, SRes);
        _ -> ok
    end.

get_user_vcard_version(User) ->
    case catch ets:lookup(vcard_version,User) of
        [] -> {<<"1">>,<<"">>};
        [Vcard] when is_record(Vcard,vcard_version) -> {Vcard#vcard_version.version,Vcard#vcard_version.url};
        _ -> {<<"1">>,<<"">>}
    end.


update_virtual_user(Server,User,Flag) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select real_user,on_duty_flag from virtual_user_list where virtual_user = '">>,User,<<"';">>]) of
        {selected,_,SRes} when is_list(SRes) ->
            case Flag of
                false -> catch ets:delete(virtual_user,User);
                _ -> ok
            end,
            Users = lists:flatmap(fun([U,F]) ->
                case F of
                    <<"1">> ->
                        [U];
                    _ ->
                        []
                end
            end,SRes),
            catch ets:insert(virtual_user,{User,Users});
        _ -> ok
    end.

update_virtual_users(Server) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select distinct(virtual_user) from virtual_user_list;">>]) of
        {selected,_,SRes} when is_list(SRes) ->
    catch ets:delete_all_objects(virtual_user),
            lists:foreach(fun([U]) ->
                update_virtual_user(Server,U,false)
            end,SRes);
        _ -> ok
    end.

update_virtual_users_v2(Server) ->
    case catch ejabberd_sql:sql_query(Server,[<<"select distinct(virtual_user) from virtual_user_list;">>]) of
        {selected,_,SRes} when is_list(SRes) ->
            lists:foreach(fun([U]) ->
                update_virtual_user(Server,U,true)
            end,SRes);
        _ -> ok
    end.

depends(_Host, _Opts) ->
    [].

mod_opt_type(_) -> [].
