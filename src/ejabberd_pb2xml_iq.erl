-module(ejabberd_pb2xml_iq).

-include("message_pb.hrl").
-include("jlib.hrl").
-include("logger.hrl").

-export([parse_iq_message/1]).

parse_iq_message(Pb_message) ->
	case catch message_pb:decode_iqmessage(Pb_message#protomessage.message) of
 	IQ when is_record(IQ,iqmessage)  ->
        To = case Pb_message#protomessage.to of
             'undefined' ->
                 %%   ejabberd_pb2xml_public:list_and_character_to_binary(Pb_message#protomessage.from);
                 'undefined';
              _ ->
                    ejabberd_pb2xml_public:list_and_character_to_binary(Pb_message#protomessage.to)
              end,
	%	make_iq_message(IQ#iqmessage.key,IQ#iqmessage.value,
	%				Pb_message#protomessage.from,To,Pb_message#protomessage.signaltype,
	%				IQ#iqmessage.messageid,IQ#iqmessage.body,IQ#iqmessage.bodys);
        case ejabberd_pb2xml_public:get_iqKey_type(IQ#iqmessage.definedkey) of
        'none' ->
	    	make_iq_message(IQ#iqmessage.key,IQ#iqmessage.value,
					Pb_message#protomessage.from,To,message_pb:int_to_enum(signaltype,Pb_message#protomessage.signaltype),
					IQ#iqmessage.messageid,IQ#iqmessage.body,IQ#iqmessage.bodys);
    	V ->
	    	make_iq_message(V,IQ#iqmessage.value,
					Pb_message#protomessage.from,To,message_pb:int_to_enum(signaltype,Pb_message#protomessage.signaltype),
					IQ#iqmessage.messageid,IQ#iqmessage.body,IQ#iqmessage.bodys)
        end;
	_ ->
		false
	end.

        

make_iq_message("BIND",Value,_From,To,_Type,ID,_Body,_Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>, 
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
			children = [#xmlel{name = <<"bind">>,
		    			   attrs = [{<<"xmlns">>,<<"urn:ietf:params:xml:ns:xmpp-bind">>}],
			    				   children = [#xmlel{name = <<"resource">>, 
					   				  attrs = [],children = [{'xmlcdata',list_to_binary(Value)}]}]}]},
	{xmlstreamelement,Xml};
make_iq_message("CREATE_MUC",Value,_From,To,_Type,ID,_Body,_Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(list_to_binary(Value),ID,<<"set">>),
			children =[#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/create_muc">>}],
						children = []},{xmlcdata,<<"">>}]},
	{xmlstreamelement,Xml};
make_iq_message("MUC_CREATE",Value,_From,To,_Type,ID,_Body,_Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
			children = 	[#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/create_muc">>}],
						children = []},{xmlcdata,<<"">>}]},
	{xmlstreamelement,Xml};
make_iq_message("MUC_INVITE_V2",Value,_From,To,_Type,ID,Body,Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
			children = [#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#invite_v2">>}],
					children = ejabberd_pb2xml_public:make_attrs_xmlels(Bodys)}]},	
	{xmlstreamelement,Xml};
make_iq_message("GET_MUC_USER",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#register">>}],children = []}]},
	case catch To#jid.lserver of 
	<<"ejabhost2">> ->
		?INFO_MSG("GET_MUC_USER XML ~p ~n",[Xml]);
	_ ->
		ok
	end,
	{xmlstreamelement,Xml};
make_iq_message("SET_MUC_USER",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
	    attrs = make_iq_master_attrs(To,ID,<<"set">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#register">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("DEL_MUC_USER",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#del_register">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("ADD_USER_SUBSCRIBE",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#muc_user_subscribe">>}],
					children = [#xmlel{name = <<"subscribe">>, attrs = [{<<"action">>,<<"add">>}],
						children = []}]}]},
	{xmlstreamelement,Xml};
make_iq_message("DEL_USER_SUBSCRIBE",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#muc_user_subscribe">>}],
					children = [#xmlel{name = <<"subscribe">>, attrs = [{<<"action">>,<<"delete">>}],
						children = []}]}]},
	{xmlstreamelement,Xml};
make_iq_message("SET_USER_SUBSCRIBE_V2",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#muc_user_subscribe_v2">>}],
					children = [#xmlel{name = <<"subscribe">>, attrs = [{<<"action">>, list_to_binary(Value)}], children = []}]}]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_SUBSCRIBE_V2",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#muc_user_subscribe_v2">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_SUBSCRIBE",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"query">>,
				attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#muc_user_subscribe">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_OPT",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"get_verify_friend_mode">>,
				attrs = [{<<"xmlns">>,<<"jabber:iq:verify_friend_mode">>},{<<"jid">>,remove_jid_domain(list_to_binary(Value))}],
                children =  [] }]},
	{xmlstreamelement,Xml};
make_iq_message("SET_USER_OPT",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Headers = Body#messagebody.headers ++ [#stringheader{key = {<<"xmlns">>},value = <<"jabber:iq:verify_friend_mode">>}],
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [ejabberd_pb2xml_public:make_attrs_xmlel(
            list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"jabber:iq:verify_friend_mode">>,[])]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_FRIEND",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"get_user_friends">>,
				attrs = [{<<"xmlns">>,<<"jabber:x:get_friend">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("DEL_USER_FRIEND",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                        list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"jabber:x:delete_friend">>,[])]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_KEY",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"key">>,attrs = [{<<"xmlns">>,<<"urn:xmpp:key">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("GET_USER_MASK",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"get">>),
		children = [#xmlel{name = <<"mask_user">>,attrs = [{<<"xmlns">>,<<"jabber:x:mask_user">>}],children = []}]},
	{xmlstreamelement,Xml};
make_iq_message("SET_USER_MASK",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                        list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"jabber:x:mask_user">>,[])]},
	{xmlstreamelement,Xml};
make_iq_message("CANCEL_USER_MASK",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                        list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"jabber:x:mask_user">>,[])]},
	{xmlstreamelement,Xml};
make_iq_message("SET_ADMIN",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [#xmlel{name = <<"query">>, attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#admin">>}],
                children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                            list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"jabber:x:mask_user">>,[])]}]},
	{xmlstreamelement,Xml};
make_iq_message("SET_MEMBER",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		  attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [#xmlel{name = <<"query">>, attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#admin">>}],
                children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                            list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"">>,[])]}]},
	{xmlstreamelement,Xml};
make_iq_message("CANCEL_MEMBER",Value,_From,To,_Type,ID,Body,_Bodys) ->
	Xml = #xmlel{name = <<"iq">>,
		    attrs = make_iq_master_attrs(To,ID,<<"set">>),
		  children = [#xmlel{name = <<"query">>, attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#admin">>}],
                children = [ejabberd_pb2xml_public:make_attrs_xmlel(
                            list_to_binary(Body#messagebody.value),Body#messagebody.headers,<<"">>,[])]}]},
	{xmlstreamelement,Xml};
make_iq_message("USER_MUCS",Value,From,To,_Type,ID,Body,Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>,
			attrs = make_iq_master_attrs(To,ID,<<"get">>),
			children = [#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#user_mucs">>}],
					children = []}]},	
    ?INFO_MSG("USER_MUCS From ~p ,To ~p,Xml ~p  ~n",[From,To,Xml]),
	{xmlstreamelement,Xml};
make_iq_message("DESTROY_MUC",Value,_From,To,_Type,ID,Body,Bodys) ->
	Xml = 
		#xmlel{name = <<"iq">>,
			attrs = make_iq_master_attrs(To,ID,<<"set">>),
			children = [#xmlel{name = <<"query">>,attrs = [{<<"xmlns">>,<<"http://jabber.org/protocol/muc#owner">>}],
					children = [#xmlel{name = <<"destroy">>,attrs = [],children = []}]}]},	
	{xmlstreamelement,Xml};
make_iq_message("PING",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"get">>),
                 children = [#xmlel{name = <<"ping">>,attrs = [{<<"xmlns">>,<<"urn:xmpp:ping">>}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("GET_SPUSH_VOICE",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"get">>),
                 children = [#xmlel{name = <<"mac_push_notice">>,attrs = [{<<"xmlns">>,?NS_MAC_PUSH_NOTICE}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("ADD_SPUSH_VOICE",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"set">>),
                 children = [#xmlel{name = <<"mac_push_notice">>,attrs = [{<<"xmlns">>,?NS_MAC_PUSH_NOTICE},{<<"jid">>,list_to_binary(Value)}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("CANCEL_SPUSH_VOICE",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"set">>),
                 children = [#xmlel{name = <<"cancel_mac_push_notice">>,attrs = [{<<"xmlns">>,?NS_MAC_PUSH_NOTICE},{<<"jid">>,list_to_binary(Value)}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("GET_VUSER",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"get">>),
                 children = [#xmlel{name = <<"get_virtual_user">>,attrs = [{<<"xmlns">>,<<"jabber:x:virtual_user">>}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("GET_VUSER_ROLE",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"get">>),
                 children = [#xmlel{name = <<"get_virtual_user_role">>,attrs = [{<<"xmlns">>,<<"jabber:x:virtual_user">>}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("RUSER_START_SESSION",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"get">>),
                 children = [#xmlel{name = <<"real_user_start_session">>,
                        attrs = [{<<"xmlns">>,<<"jabber:x:virtual_user">>},{<<"jid">>,list_to_binary(Value)}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message("RUSER_END_SESSION",Value,_From,To,_Type,ID,Body,Bodys) ->
    Xml = 
        #xmlel{name = <<"iq">>,
            attrs = make_iq_master_attrs(To,ID,<<"set">>),
                 children = [#xmlel{name = <<"real_user_end_session">>,
                        attrs = [{<<"xmlns">>,<<"jabber:x:virtual_user">>},{<<"jid">>,list_to_binary(Value)}],children = []}]},
    {xmlstreamelement,Xml};
make_iq_message(_,_,_,_,_,_,_,_) ->
	false.

make_iq_master_attrs('undefined',ID,Type) ->
    [{<<"id">>,list_to_binary(ID)},{<<"type">>,Type}];
make_iq_master_attrs(To,ID,Type) when is_list(To) ->
     [{<<"to">>,list_to_binary(To)},{<<"id">>,list_to_binary(ID)},{<<"type">>,Type}];
make_iq_master_attrs(To,ID,Type) when is_binary(To) ->
     [{<<"to">>,To},{<<"id">>,list_to_binary(ID)},{<<"type">>,Type}];
make_iq_master_attrs(_,ID,Type) ->
     [{<<"id">>,list_to_binary(ID)},{<<"type">>,Type}].
        

remove_jid_domain(JID) when is_binary(JID) ->
    case catch str:str(JID,<<"@">>) of
    0 ->
        JID;
    N when is_integer(N) ->
        str:substr(JID,1,N-1);
    _ ->
        JID
    end;
remove_jid_domain(JID) ->
    JID.
