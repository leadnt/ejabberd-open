-module(qtalk_ets_table).

-export([create_ets_table/0,stop_ets_table/0]).

-include("logger.hrl").

create_ets_table() ->
	catch ets:new(nicks, [named_table, ordered_set, public,{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(department_users, [bag, named_table, public, {keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(multiple_users, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(blacklist, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(black_version, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(userlist, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(whitelist, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(user_last_key, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(nick_name, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(host_info, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(mac_push_notice,[set,named_table,public,{keypos,2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(shield_user, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(user_mask_list, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(vcard_version,    [named_table, ordered_set, public,{keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(virtual_session,  [named_table, ordered_set, public,{keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(virtual_user,  [named_table, ordered_set, public,{keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(flogin_list, [set, named_table, public, {keypos, 1},{write_concurrency, true}, {read_concurrency, true}]),

	subscription:create_rbt_ets().

stop_ets_table() ->
	catch ets:delete(nicks),
	catch ets:delete(department_users),
	catch ets:delete(sn_user),
	catch ets:delete(blacklist),
	catch ets:delete(black_version),
	catch ets:delete(userlist),
	catch ets:delete(whitelist),
	catch ets:delete(host_info),
	catch ets:delete(user_last_key),
	catch ets:delete(nick_name),
	catch ets:delete(vcard_version),
	catch ets:delete(flogin_list),
	catch ets:delete(mac_push_notice).


