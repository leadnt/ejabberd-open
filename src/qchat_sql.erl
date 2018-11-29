-module(qchat_sql).

-export([insert_domain_msg/8,
         insert_domain_note_msg/8,
         insert_domain_msg_autoreply/8,
	 insert_muc_vcard_info/7,
         get_muc_users/3,
         add_spool_sql/2,
         add_spool_sql/4,
         add_spool/2]).

insert_domain_note_msg(LServer, From, To, From_host, To_host, Body, MsgId, ChatId) ->
    ejabberd_sql:sql_query(LServer,
        [<<"insert into note_msg_history(m_from,m_to,from_host,to_host,m_body, msg_id, chat_id)"
                "values ('">>,
                From,<<"','">>,To,<<"','">>,From_host,<<"','">>,To_host,<<"','">>,Body,<<"','">>, MsgId, <<"','">>, ChatId, <<"');">>]).

insert_domain_msg(LServer, From, To, From_host, To_host, Body, MsgId, ChatId) ->
    ejabberd_sql:sql_query(LServer,
        [<<"insert into msg_history(m_from,m_to,from_host,to_host,m_body, msg_id, chat_id)"
                "values ('">>,
                From,<<"','">>,To,<<"','">>,From_host,<<"','">>,To_host,<<"','">>,Body,<<"','">>, MsgId, <<"','">>, ChatId, <<"');">>]).

insert_domain_msg_autoreply(LServer, From, To, From_host, To_host, Body, MsgId, ChatId) ->
    ejabberd_sql:sql_query(LServer,
        [<<"insert into autoreply_history(m_from,m_to,from_host,to_host,m_body, msg_id, chat_id)"
                "values ('">>,
                From,<<"','">>,To,<<"','">>,From_host,<<"','">>,To_host,<<"','">>,Body,<<"','">>, MsgId, <<"','">>, ChatId, <<"');">>]).

add_spool_sql(FromUsername, Username, XML, MsgId) ->
    [<<"insert into spool(from_username, username, xml, msg_id) values ('">>,
     FromUsername, <<"', '">>, Username, <<"', '">>, XML, <<"', '">>, MsgId, <<"');">>].

add_spool_sql(Username, XML) ->
    [<<"EXECUTE dbo.add_spool '">>, Username, <<"' , '">>,
     XML, <<"'">>].

add_spool(LServer, Queries) ->
    lists:foreach(fun (Query) ->
			  ejabberd_sql:sql_query(LServer, Query)
		  end,
		  Queries).

insert_muc_vcard_info(LServer,Mucname,Nick,Desc,Title,Pic,Version) ->
	ejabberd_sql:sql_query(LServer,
			[<<"insert into muc_vcard_info(muc_name,show_name,muc_desc,muc_title,muc_pic,version) values ('">>,Mucname,<<"','">>,
				Nick,<<"','">>,Desc,<<"','">>,Title,<<"','">>,Pic,<<"','">>,Version,<<"');">>]).

get_muc_users(LServer,Tabname,Muc_name) ->
	ejabberd_sql:sql_query(LServer,
		[<<"select muc_name,username,host from ">>,Tabname,<<" where muc_name = '">>,Muc_name,<<"';">>]).
