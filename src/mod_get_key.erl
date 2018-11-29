%%%----------------------------------------------------------------------
%%% File    : mod_ping.erl
%%% Author  : Brian Cully <bjc@kublai.com>
%%% Purpose : Support XEP-0199 XMPP Ping and periodic keepalives
%%% Created : 11 Jul 2009 by Brian Cully <bjc@kublai.com>
%%%
%%%
%%% ejabberd, Copyright (C) 2002-2014   ProcessOne
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License along
%%% with this program; if not, write to the Free Software Foundation, Inc.,
%%% 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%%%
%%%----------------------------------------------------------------------

-module(mod_get_key).

-behavior(gen_mod).

-include("ejabberd.hrl").
-include("logger.hrl").

-include("jlib.hrl").

-define(SUPERVISOR, ejabberd_sup).

%% gen_mod callbacks
-export([start/2, stop/1]).

%% Hook callbacks
-export([get_key/3,
         make_key_and_token/3]).

%%====================================================================
%% gen_mod callbacks
%%====================================================================
start(Host, Opts) ->
    IQDisc = gen_mod:get_opt(iqdisc, Opts, fun gen_iq_handler:check_type/1,
                             parallel),
    gen_iq_handler:add_iq_handler(ejabberd_sm, Host,
                                  ?NS_KEY, ?MODULE, get_key, IQDisc),
    gen_iq_handler:add_iq_handler(ejabberd_local, Host,
            ?NS_KEY, ?MODULE, get_key, IQDisc).

stop(Host) ->
    gen_iq_handler:remove_iq_handler(ejabberd_local, Host,
            ?NS_KEY),
    gen_iq_handler:remove_iq_handler(ejabberd_sm, Host,
            ?NS_KEY).

get_key(From, _To, #iq{type = Type, sub_el = SubEl} = IQ) ->
    case {Type, SubEl} of
        {get, #xmlel{name = <<"key">>}} ->
            IQ#iq{type = result, sub_el = [make_iq_key_reply(From)]};
        _ ->
            IQ#iq{type = error,
            sub_el = [SubEl, ?ERR_FEATURE_NOT_IMPLEMENTED]}
    end.


make_iq_key_reply(From) ->
    Resource = From#jid.resource,
    User = From#jid.user,
    LServer = jlib:nameprep(From#jid.server),

    {Key, Token} = make_key_and_token(LServer, User, Resource),
    #xmlel{name = <<"key">>,
           attrs = [{<<"xmlns">>,?NS_KEY},
                    {<<"value">>,Key},
                    {<<"token">>,Token}],
           children = []}.

make_key_and_token(LServer, User, Resource) ->
    case catch redis_link:hash_get(LServer, 1, User, Resource) of
	    {ok, Key} when Key =/= undefined ->
			{Key, <<"unused">>};
	     _ ->
			Key = iolist_to_binary([randoms:get_string() | [jlib:integer_to_binary(X)|| X <- tuple_to_list(os:timestamp())]]),
			catch redis_link:hash_set(LServer,1,User,Resource, Key),
			catch redis_link:hash_set(LServer,2,User,Key, Key),
			catch redis_link:expire_time(LServer,2,User,86400*7),
			{Key, <<"unused">>}
   end.
