-module(subscription).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

-export([subscription_message/3,create_rbt_ets/0,get_subscription_url/1,update_subscription_info/1]).
-export([update_user_robots/1,get_subscription_cn_name/1]).

-record(rbt_info,{name,host,cn_name,url,body,version}).
-record(user_rbts,{name,rbt,rhost}).
-record(rbts_map,{cn_name,en_name}).


subscription_message(From,To,Packet) ->
    case catch fxml:get_tag_attr_s(<<"direction">>, Packet) of 
    <<"1">> ->
        ok;
    _ ->
        do_subscription_message(From,To,Packet)
    end.
    

%	#xmlel{name = Name, attrs = Attrs, children = Els} = Packet,
	%%case catch xml:get_tag_attr_s(<<"id">>,xml:get_subtag(El,<<"body">>)) of

do_subscription_message(From,To,Packet) ->
	Msg_Body = fxml:get_subtag_cdata(Packet, <<"body">>),
	{Is_Muc,User} = 
        case catch str:str(From#jid.lserver,<<"conference.">>) of
        N when is_integer(N) andalso N > 0 ->
            {<<"1">>,From#jid.lresource};
        _ ->
            {<<"0">>,<<"">>}
        end,
	Body = rfc4627:encode({obj,[{"from",From#jid.luser},{"body",Msg_Body},{"is_muc",Is_Muc},{"domain",From#jid.lserver},{"user",User}]}),
	?DEBUG("Args Json ~p ~n",[Body]),
	Header = [],
	Type = "application/json",
	HTTPOptions = [{timeout,1500}],
	Options = [],
	Host = To#jid.lserver,
	case get_subscription_url({To#jid.luser,To#jid.lserver}) of
	error ->
		?INFO_MSG("User ~p ,No found requeset url,Packet ~p  ~n",[To#jid.luser,Packet]),
		error;
	Url ->
		Res = http_client:http_post(Host,binary_to_list(Url), Header, Type, Body, HTTPOptions, Options),
		?INFO_MSG("Rbt ~p Url:~p, Body: ~p, ret Res ~p ~n",[To#jid.luser,Url, Body, Res]),
		Res
	end.

create_rbt_ets() ->
	catch ets:new(rbt_info, [named_table, ordered_set, public,{keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(user_rbts, [named_table, bag, public,{keypos, 2},{write_concurrency, true}, {read_concurrency, true}]),
	catch ets:new(rbts_map, [named_table, ordered_set, public,{keypos, 2},{write_concurrency, true}, {read_concurrency, true}]).

update_subscription_info(Server) ->
    ets:delete_all_objects(rbt_info),
    ets:delete_all_objects(rbts_map),
    case catch qtalk_sql:get_rbt_info(Server) of
	{selected,_,Res} when is_list(Res) ->
			lists:foreach(fun([Name,Host,CName,Url,Body,Version]) ->
                catch ets:insert(rbts_map,#rbts_map{cn_name = {CName,Host},en_name = {Name,Host}}),
				catch ets:insert(rbt_info,#rbt_info{name = {Name,Host},cn_name = CName,url = Url,body = Body,version = Version}) end,Res);
	_ ->
		ok
	end.

get_subscription_url(Name) ->
	case catch ets:lookup(rbt_info,Name) of 
	[SI] when is_record(SI,rbt_info) ->
		SI#rbt_info.url;
    _ ->
        error
	end.

get_subscription_cn_name({Name, Host}) ->
    case catch ets:lookup(rbt_info, {Name, Host}) of
    [SI] when is_record(SI,rbt_info) ->
        SI#rbt_info.cn_name;
    _ ->
        Name
    end.
    

update_user_robots(Server) ->
	ets:delete_all_objects(user_rbts),
	case catch qtalk_sql:get_rbt_pubsub(Server) of
	{selected, _,SRes} when is_list(SRes) ->
		lists:foreach(fun([User,UHost,Rbt,RHost]) ->
			ets:insert(user_rbts,#user_rbts{name = {User,UHost},rbt = Rbt,rhost = RHost}) end,SRes);
	_ ->
		ok
	end.
