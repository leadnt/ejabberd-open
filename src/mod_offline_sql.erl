%%%-------------------------------------------------------------------
%%% @author Evgeny Khramtsov <ekhramtsov@process-one.net>
%%% @copyright (C) 2016, Evgeny Khramtsov
%%% @doc
%%%
%%% @end
%%% Created : 15 Apr 2016 by Evgeny Khramtsov <ekhramtsov@process-one.net>
%%%-------------------------------------------------------------------
-module(mod_offline_sql).

-compile([{parse_transform, ejabberd_sql_pt}]).

-behaviour(mod_offline).

-export([init/2, store_messages/5, pop_messages/2, remove_expired_messages/1,
	 remove_old_messages/2, remove_user/2, read_message_headers/2,
	 read_message/3, remove_message/3, read_all_messages/2,
	 remove_all_messages/2, count_messages/2, import/1, import/2,
	 export/1]).

-export([make_single_http_body/11]).

-include("jlib.hrl").
-include("mod_offline.hrl").
-include("logger.hrl").
-include("ejabberd.hrl").
-include("ejabberd_sql_pt.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init(_Host, _Opts) ->
    ok.

store_messages(Host, {User, _Server}, Msgs, Len, MaxOfflineMsgs) ->
    ?DEBUG("store mssage ~p ~n",[Msgs]),
    Count = if MaxOfflineMsgs =/= infinity ->
		    Len + count_messages(User, Host);
	       true -> 0
	    end,
    if Count > MaxOfflineMsgs -> {atomic, discard};
       true ->
       %     insert_sql_spool(Host,Msgs)
             make_offline_http_body(Host,Msgs)
    end.

%store_messages(Host, {User, _Server}, Msgs, Len, MaxOfflineMsgs) ->
%	insert_sql_spool(Host,Msgs).

insert_sql_spool(Host,Msgs) ->
	  %  Query = lists:map(
	  lists:foreach(
		      fun(M) ->
			      LUser = (M#offline_msg.to)#jid.luser,
			      From = M#offline_msg.from,
                  FromUser =  ejabberd_sql:escape((M#offline_msg.from)#jid.luser),
			      To = M#offline_msg.to,
			      Packet =
				  jlib:replace_from_to(From, To,
						       M#offline_msg.packet),
			      NewPacket =
				  jlib:add_delay_info(Packet, Host,
						      M#offline_msg.timestamp,
						      <<"Offline Storage">>),
			      XML = fxml:element_to_binary(NewPacket),
                  case catch fxml:get_subtag(Packet, <<"body">>) of
                  MBody when MBody =/= false  ->
                    case catch fxml:get_tag_attr_s(<<"msgType">>,MBody) /= <<"1024">> of
                    false  ->
                        [];
                    _ ->
                   %   qtalk_sql:add_spool_sql_v2(FromUser,LUser, XML)
                        sql_queries:insert_spool_sql_v2(Host,FromUser,LUser, XML)
                    end;
                  _ ->
                        []
                  end
		      end,
		      Msgs).
%	    sql_queries:add_spool(Host, Query).

pop_messages(LUser, LServer) ->
    case sql_queries:get_and_del_spool_msg_t(LServer, LUser) of
    {selected,_,Rs} ->
	    {ok, lists:flatmap(
		   fun([_, XML]) ->
			   case xml_to_offline_msg(XML) of
			       {ok, Msg} ->
				   [Msg];
			       _Err ->
				   []
			   end
		   end, Rs)};
	Err ->
	    {error, Err}
    end.

remove_expired_messages(_LServer) ->
    %% TODO
    {atomic, ok}.

remove_old_messages(Days, LServer) ->
    case catch ejabberd_sql:sql_query(
		 LServer,
		 [<<"DELETE FROM spool"
		   " WHERE created_at < "
		   "NOW() - INTERVAL '">>,
		  integer_to_list(Days), <<"';">>]) of
	{updated, N} ->
	    ?INFO_MSG("~p message(s) deleted from offline spool", [N]);
	_Error ->
	    ?ERROR_MSG("Cannot delete message in offline spool: ~p", [_Error])
    end,
    {atomic, ok}.

remove_user(LUser, LServer) ->
    sql_queries:del_spool_msg(LServer, LUser).

read_message_headers(LUser, LServer) ->
    case catch ejabberd_sql:sql_query(
		 LServer,
                 ?SQL("select @(xml)s, @(seq)d from spool"
                      " where username=%(LUser)s order by seq")) of
	{selected, Rows} ->
	    lists:flatmap(
	      fun({XML, Seq}) ->
		      case xml_to_offline_msg(XML) of
			  {ok, #offline_msg{from = From,
					    to = To,
					    packet = El}} ->
			      [{Seq, From, To, El}];
			  _ ->
			      []
		      end
	      end, Rows);
	_Err ->
	    []
    end.

read_message(LUser, LServer, Seq) ->
    case ejabberd_sql:sql_query(
	   LServer,
	   ?SQL("select @(xml)s from spool where username=%(LUser)s"
                " and seq=%(Seq)d")) of
	{selected, [{RawXML}|_]} ->
	    case xml_to_offline_msg(RawXML) of
		{ok, Msg} ->
		    {ok, Msg};
		_ ->
		    error
	    end;
	_ ->
	    error
    end.

remove_message(LUser, LServer, Seq) ->
    ejabberd_sql:sql_query(
      LServer,
      ?SQL("delete from spool where username=%(LUser)s"
           " and seq=%(Seq)d")),
    ok.

read_all_messages(LUser, LServer) ->
    case catch ejabberd_sql:sql_query(
                 LServer,
                 ?SQL("select @(xml)s from spool where "
                      "username=%(LUser)s order by seq")) of
        {selected, Rs} ->
            lists:flatmap(
              fun({XML}) ->
		      case xml_to_offline_msg(XML) of
			  {ok, Msg} -> [Msg];
			  _ -> []
		      end
              end, Rs);
        _ ->
	    []
    end.

remove_all_messages(LUser, LServer) ->
    sql_queries:del_spool_msg(LServer, LUser),
    {atomic, ok}.

count_messages(LUser, LServer) ->
%%     case catch ejabberd_sql:sql_query(
%%                 LServer,
%%           %      ?SQL("select @(count(*))d from spool "
%%            %          "where username=%(LUser)s")) of
%%             [<<"select count(*) from spool where username= '">>,LUser,<<"';">>]) of
%%        {selected,_, [[Res]]} when is_binary(Res)->
%%            binary_to_integer(Res);
%%        _ -> 0
%%    end.
    0.

export(_Server) ->
    [{offline_msg,
      fun(Host, #offline_msg{us = {LUser, LServer},
                             timestamp = TimeStamp, from = From, to = To,
                             packet = Packet})
            when LServer == Host ->
              Packet1 = jlib:replace_from_to(From, To, Packet),
              Packet2 = jlib:add_delay_info(Packet1, LServer, TimeStamp,
                                            <<"Offline Storage">>),
              XML = fxml:element_to_binary(Packet2),
              [?SQL("delete from spool where username=%(LUser)s;"),
               ?SQL("insert into spool(username, xml) values ("
                    "%(LUser)s, %(XML)s);")];
         (_Host, _R) ->
              []
      end}].

import(LServer) ->
    [{<<"select username, xml from spool;">>,
      fun([LUser, XML]) ->
              El = #xmlel{} = fxml_stream:parse_element(XML),
              From = #jid{} = jid:from_string(
                                fxml:get_attr_s(<<"from">>, El#xmlel.attrs)),
              To = #jid{} = jid:from_string(
                              fxml:get_attr_s(<<"to">>, El#xmlel.attrs)),
              Stamp = fxml:get_path_s(El, [{elem, <<"delay">>},
                                          {attr, <<"stamp">>}]),
              TS = case jlib:datetime_string_to_timestamp(Stamp) of
                       {_, _, _} = Now ->
                           Now;
                       undefined ->
                           p1_time_compat:timestamp()
                   end,
              Expire = mod_offline:find_x_expire(TS, El#xmlel.children),
              #offline_msg{us = {LUser, LServer},
                           from = From, to = To,
			   packet = El,
                           timestamp = TS, expire = Expire}
      end}].

import(_, _) ->
    pass.

%%%===================================================================
%%% Internal functions
%%%===================================================================
xml_to_offline_msg(XML) ->
    case fxml_stream:parse_element(XML) of
	#xmlel{} = El ->
	    el_to_offline_msg(El);
	Err ->
	    ?ERROR_MSG("got ~p when parsing XML packet ~s",
		       [Err, XML]),
	    Err
    end.

el_to_offline_msg(El) ->
    To_s = fxml:get_tag_attr_s(<<"to">>, El),
    From_s = fxml:get_tag_attr_s(<<"from">>, El),
    To = jid:from_string(To_s),
    From = jid:from_string(From_s),
    if To == error ->
	    ?ERROR_MSG("failed to get 'to' JID from offline XML ~p", [El]),
	    {error, bad_jid_to};
       From == error ->
	    ?ERROR_MSG("failed to get 'from' JID from offline XML ~p", [El]),
	    {error, bad_jid_from};
       true ->
	    {ok, #offline_msg{us = {To#jid.luser, To#jid.lserver},
			      from = From,
			      to = To,
			      timestamp = undefined,
			      expire = undefined,
			      packet = El}}
    end.


make_offline_http_body(Host,Msgs) ->
    make_offline_http_body(Host,Msgs, ?PLATFORM).
%    make_offline_http_body(Host,Msgs, qchat).

make_offline_http_body(Host,Msgs, qchat) ->
    lists:foreach(fun(M) -> ejabberd_sm:qchat_insert_away_spool(M#offline_msg.from,
                                        M#offline_msg.to,
                                        M#offline_msg.packet,
                                        ejabberd_sql:escape((M#offline_msg.to)#jid.lserver))
                  end, Msgs);
make_offline_http_body(Host,Msgs, _) ->
    Http_Body = lists:flatmap(fun (M) ->
        Username = ejabberd_sql:escape((M#offline_msg.to)#jid.luser),
        FromUsername = ejabberd_sql:escape((M#offline_msg.from)#jid.luser),
        FServer = ejabberd_sql:escape((M#offline_msg.from)#jid.lserver),
        From = M#offline_msg.from,
        To = M#offline_msg.to,
        TServer = ejabberd_sql:escape((M#offline_msg.to)#jid.lserver),
        #xmlel{name = Name, attrs = Attrs, children = Els} =  M#offline_msg.packet,
        Attrs2 =  jlib:replace_from_to_attrs(jlib:jid_to_string(From),jlib:jid_to_string(To), Attrs),
        Packet = #xmlel{name = Name, attrs = Attrs2, children =  Els ++ 
                [jlib:timestamp_to_xml(calendar:now_to_universal_time(M#offline_msg.timestamp), utc,
                                           jlib:make_jid(<<"">>, Host, <<"">>), <<"Offline Storage">>),
                                    jlib:timestamp_to_xml(calendar:now_to_universal_time(M#offline_msg.timestamp))]},
   %     XML =   ejabberd_sql:escape(fxml:element_to_binary(Packet)),
        case fxml:get_subtag(Packet, <<"body">>) of
        Mbody when is_record(Mbody,xmlel) ->
            Body = fxml:get_subtag_cdata(Packet, <<"body">>),
            OFrom = fxml:get_attr_s(<<"originfrom">>, Attrs),
            OType = fxml:get_attr_s(<<"origintype">>, Attrs),
	    Auto = fxml:get_attr_s(<<"auto_reply">>, Attrs),
	    Atuo = fxml:get_attr_s(<<"atuo_reply">>, Attrs),
	
            case catch fxml:get_tag_attr_s(<<"msgType">>,Mbody) of
            <<"1024">>  ->
                   [];
            <<"">> ->
                    make_single_http_body(Auto,Atuo,Username,TServer,FromUsername,FServer,Body,<<"1">>, OFrom, OType, Packet);
            MsgType ->
                   ?DEBUG("Msg ~p ~n",[MsgType]),
                    make_single_http_body(Auto,Atuo,Username,TServer,FromUsername,FServer,Body,MsgType, OFrom, OType, Packet)
            end;
         _ ->
            []
         end
      end, Msgs),
    ?DEBUG("the push msg body is ~p~n", [Http_Body]),
    catch send_kafka_msg:send_kafka_msg(<<"custom_vs_qtalk_push_message">>, <<"chat">>, rfc4627:encode(Http_Body)).
%    qtalk_public:send_http_offline_msg(Host,rfc4627:encode(Http_Body)).

make_single_http_body(<<"true">>,_,To,TServer,From,FServer,Body,MsgType, OFrom, OType, Packet) ->
	[];
make_single_http_body(_,<<"true">>,To,TServer,From,FServer,Body,MsgType, OFrom, OType, Packet) ->
	[];
make_single_http_body(_,_,To,TServer,From,FServer,Body,MsgType, OFrom, OType, Packet) ->
    Message = fxml:element_to_binary(Packet),
    NFalg = case catch ets:lookup(mac_push_notice,{To,From}) of
            [_] ->
                %%静音
                <<"1">>;
            _ ->
                %%不静音
                <<"0">>
            end,
    R =
    case OType of
        <<"groupchat">> ->
            JFrom = jlib:string_to_jid(OFrom),
            [{obj,[{<<"username">>,To},{<<"tohost">>,TServer},{<<"message">>,Body},{<<"fromname">>,From},{<<"fromhost">>,FServer},
             {<<"notice_flag">>,NFalg},{<<"msg_type">>,MsgType},{"type",<<"single">>},{"count",<<"1">>}, {"originfrom", JFrom#jid.luser}, {"originserver", JFrom#jid.lserver}, {"originnick", JFrom#jid.lresource}, {"origintype", OType}, {"xml", Message}]}];
        T when T =/= <<"">> ->
            JFrom = jlib:string_to_jid(OFrom),
            [{obj,[{<<"username">>,To},{<<"tohost">>,TServer},{<<"message">>,Body},{<<"fromname">>,From},{<<"fromhost">>,FServer},
             {<<"notice_flag">>,NFalg},{<<"msg_type">>,MsgType},{"type",<<"single">>},{"count",<<"1">>}, {"originfrom", JFrom#jid.luser}, {"originserver", JFrom#jid.lserver}, {"origintype", OType}, {"xml", Message}]}];
        _ ->
            [{obj,[{<<"username">>,To},{<<"tohost">>,TServer},{<<"message">>,Body},{<<"fromname">>,From},{<<"fromhost">>,FServer},
             {<<"notice_flag">>,NFalg},{<<"msg_type">>,MsgType},{"type",<<"single">>},{"count",<<"1">>}, {"origintype", OType}, {"xml", Message}]}]
    end,
    ?DEBUG("the make single http body is ~p~n", [R]),
    R.
