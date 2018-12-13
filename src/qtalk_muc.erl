%%%%%%----------------------------------------------------------------------
%%%%%% File    : qtalk_muc.erl
%%%%%% Purpose : qtalk_muc_room
%%%%%%----------------------------------------------------------------------

-module(qtalk_muc).

-include("ejabberd.hrl").
-include("logger.hrl").

-include("jlib.hrl").

-include("mod_muc_room.hrl").

-export([create_ets_table/0, init_ets_muc_users/3,make_default_presence_packet/1,add_subscribe_users/5]).
-export([get_muc_registed_user_num/2,set_muc_room_users/5,del_muc_room_users/5,del_subscribe_users/4]).
-export([init_ets_muc_user/3]).
-export([del_ets_subscribe_users/2,del_ets_muc_room_users/2,do_del_subscribe_users/5]).
-export([update_subscribe_users/7]).

create_ets_table() ->
    catch ets:new(muc_users,[set,named_table,public,{keypos,1},{write_concurrency, true}, {read_concurrency, true}]),
    catch ets:new(muc_subscribe_users,[set,named_table,public,{keypos,2},{write_concurrency, true}, {read_concurrency, true}]).


%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 初始化ets表，muc_users/muc_subscribe_users
%%%%%%%%%%%--------------------------------------------------------------------

init_ets_muc_users(Server,Muc, Domain) ->
    init_ets_muc_user(Server,Muc, Domain),
    init_ets_muc_get_user_muc_subscriber(Server,Muc, Domain).

init_ets_muc_user(Server,Muc, Domain) ->
    case catch qtalk_sql:get_muc_users(Server,Muc, Domain) of
    {selected,_,Res} when is_list(Res) ->
        UL = lists:flatmap(fun([U,H]) ->
                case str:str(H,<<"conference">>) of
                0 ->
                    [{U,H}];
                _ ->
                    []
               end end,Res),
        case UL of
        [] ->
            ok;
        _ ->
            ets:insert(muc_users,{{Muc, Domain},UL})
        end;
    _ ->
        ok
    end.

init_ets_muc_get_user_muc_subscriber(Server,Muc, Domain) ->
    case catch qtalk_sql:get_user_muc_subscribe(Server,Muc, Domain) of
    {selected,_,SRes} when is_list(SRes) ->
        Users = 
            lists:foldl(fun([U,H],Acc) ->
                case str:str(H,<<"conference">>) of
                0 ->
                    [{{U,H},<<"1">>}|Acc];
                _ ->
                    Acc
                end end,[],SRes),
        case Users of
        [] ->
            ok;
        _ ->
            ets:insert(muc_subscribe_users,#subscribe_users{room = {Muc, Domain},users  = Users})
        end;
    _ ->
        ok
    end.


%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% make presence packet
%%%%%%%%%%%--------------------------------------------------------------------

make_default_presence_packet(ItemAttrs) ->
    #xmlel{name = <<"presence">>,
        attrs = [{<<"priority">>,<<"5">>},{<<"version">>,<<"2">>}],
            children = [
                #xmlel{name = <<"x">>,
                 attrs =[{<<"xmlns">>,
                        ?NS_MUC_USER}],
                 children = [
                        #xmlel{name = <<"item">>,attrs = ItemAttrs,children =  []},
                        #xmlel{name = <<"status">>,attrs = [{<<"code">>, <<"110">>}],children = []}]}]}.


%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 向ets表中添加群用户成员
%%%%%%%%%%%--------------------------------------------------------------------

set_muc_room_users(Server,User,Room,Domain,Host) ->
    case ets:lookup(muc_users,{Room,Domain}) of
    [] ->
        U1 = case catch qtalk_sql:get_muc_users(Server,Room, Domain) of
            {selected, _,SRes}    when is_list(SRes) ->
                lists:flatmap(fun([U,H]) ->
                        [{U,H}] end,SRes);
            _ ->
                []
            end,
        do_set_muc_room_users(Server,Room, Domain, User,Host,U1);
    [{_,UL}] when is_list(UL) ->
        do_set_muc_room_users(Server,Room, Domain, User,Host,UL)
    end.

do_set_muc_room_users(Server,Room, Domain, User, Host,UL) ->
    case lists:member({User, Host},UL) of
    true ->
        catch ets:insert(muc_users,{{Room,Domain}, UL}),
        false;
    false ->
        U2 = lists:append([[{User, Host}],UL]),
        catch ets:insert(muc_users,{{Room,Domain}, U2}),
        catch add_subscribe_users(Server,User,Host,Room, Domain),
        catch qtalk_sql:insert_muc_users_sub_push(Server,Room, Domain, User, Host),
        true
    end.

%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 获取群用户注册的数量
%%%%%%%%%%%--------------------------------------------------------------------
get_muc_registed_user_num(Room,Domain) ->
    case ets:lookup(muc_users,{Room,Domain}) of
    [] ->
        0;
    [{_,U}] when is_list(U) ->
        length(U);
    _ ->
        0
    end.


%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 删除ets表中muc_room_users数据
%%%%%%%%%%%--------------------------------------------------------------------
del_muc_room_users(Server,Room, Domain, User,Host) ->
    case ets:lookup(muc_users,{Room,Domain}) of
    [] ->
        ok;
    [{_,UL}] when UL /= [] ->
        case lists:delete({User,Host},UL) of
        UL ->
            ok;
        UDL when is_list(UDL) ->
            if UDL =:= [] ->
                ets:delete(muc_users,{Room,Domain});
            true ->
                ets:insert(muc_users,{{Room,Domain},UDL})
            end;
        _ ->
            ok
        end;
    _ ->
        ok
    end,
    catch qtalk_sql:del_muc_user(Server,Room, Domain, User).

%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 向ets表中添加群订阅用户成员
%%%%%%%%%%%--------------------------------------------------------------------

add_subscribe_users(Server,User,Host,Room, Domain) ->
    update_subscribe_users(true,Server,User,Host,Room, Domain, <<"1">>).

update_subscribe_users(Flag,Server,User,Host,Room, Domain, SFlag) ->
    case catch ets:lookup(muc_subscribe_users,{Room, Domain}) of
    [] ->
        ets:insert(muc_subscribe_users,#subscribe_users{room = {Room, Domain},users  = [{{User, Host},SFlag}]}),
	sql_add_muc_subscribe_users(Flag,Server,User,Host,Room, Domain, SFlag);
    [SL] ->
        case lists:keyfind({User,Host},1, SL#subscribe_users.users) of
        {_,_}  ->
                SL2 = lists:keyreplace({User,Host}, 1, SL#subscribe_users.users, {{User,Host}, SFlag}),
                ets:insert(muc_subscribe_users,#subscribe_users{room = {Room, Domain} ,users  = SL2}),
                sql_add_muc_subscribe_users(Flag,Server,User,Host,Room, Domain, SFlag);
        false ->
                SL2 = [{{User,Host} ,SFlag}|SL#subscribe_users.users],
                ets:insert(muc_subscribe_users,#subscribe_users{room = {Room, Domain} ,users  = SL2}),
                sql_add_muc_subscribe_users(Flag,Server,User,Host,Room, Domain, SFlag)
        end;
    _ ->
        false
    end.

sql_add_muc_subscribe_users(Flag,Server,User,Host,Room, Domain, SFlag) ->
        if Flag =:= false ->
            case catch qtalk_sql:add_user_muc_subscribe(Server,Room, Domain, User,Host, SFlag) of
		{updated,1} ->
			true;
	   	O ->
                        ?ERROR_MSG("the xxxxx ~p~n", [O]),
			false
		end;
        true ->
            true
        end.
%%%%%%%%%%%--------------------------------------------------------------------
%%%%%%%%%%% @date 2017-03-01
%%%%%%%%%%% 删除ets表中订阅ｐｕｓｈ数据
%%%%%%%%%%%--------------------------------------------------------------------
del_subscribe_users(Server,Room, Domain, User) ->
  do_del_subscribe_users(true,Server,Room, Domain, User).  

do_del_subscribe_users(Flag,Server,Room, Domain, User) ->
    case catch ets:lookup(muc_subscribe_users,{Room,Domain}) of
    [] ->
        true;
    [SL] ->
        case lists:member(User,SL#subscribe_users.users) of
        true ->
            NL = lists:delete(User,SL#subscribe_users.users),
            case length(NL) of
            0 ->
                ets:delete(muc_subscribe_users,{Room,Domain});
            _ ->
                ets:insert(muc_subscribe_users,#subscribe_users{room = {Room,Domain},users  = NL})
            end,
	    sql_el_subscribe_users(Flag,Server,Room, Domain, User);
        _ ->
            true
        end;
    _ ->
        false
    end.

sql_el_subscribe_users(Flag,Server,Room, Domain, User) ->
            if Flag =:= false ->
                case catch qtalk_sql:del_user_muc_subscribe(Server,Room, Domain, User) of
		{updated,1} ->
			true;
		_ ->
			false
		end;
            true ->
                true  
            end.

del_ets_subscribe_users(_Server,Room) ->
	catch ets:delete(muc_subscribe_users,Room).

del_ets_muc_room_users(_Server,Room) ->
	catch ets:delete(muc_room_users,Room).
