-module(subscribe_msg).

-export([insert_subscribe_msg_v2/9]).

-include("ejabberd.hrl").
-include("logger.hrl").
-include("jlib.hrl").

-record(rbts_map,{cn_name,en_name}).
-record(rbt_info,{name,cn_name,url,body,version}).


insert_subscribe_msg_v2(Room,ConServer,User,Nick,Xml,Packet,Body,MsgType) -> 
	insert_subscribe_msg_v2(?SERVER_KEY,Room,ConServer,User,Nick,Xml,Packet,Body,MsgType).

insert_subscribe_msg_v2(Host,Room,ConServer,User,Nick,Xml,Packet,Body,MsgType) ->
	case str:str(Body,<<"@">>) of
	0 ->
	    ok;
	_ ->
		do_check_at_user(Body,Room,ConServer,User,Host)
	end.

do_check_at_user(Body,Muc,Domain,FUser,Host) -> 
    Split_str = str:tokens(Body,<<"@">>),
    case Split_str of
    [] ->
        [];
    _ ->
        Str = lists:nth(1,Split_str),
        Users = str:tokens(Str,<<" ">>),
        case Users of [] ->
            [];
        L when is_list(L) ->
            User = lists:nth(1,Users),
            handle_rbt_user(Muc,Domain,User,Body,FUser,Host),
	    [];
        _ ->
            []
        end
    end.
        
handle_rbt_user(Muc,Domain,Cn_name,[],FUser,Host) ->
    ok;
handle_rbt_user(Muc,Domain,Cn_name,Body,FUser,Host) ->
    case catch check_rbt_user(Cn_name,Host) of
    [] ->
        ok;
    {User,UHost} when is_binary(User) ->
        case true of
        true ->
            ?INFO_MSG("User ~p get subscription info ~p",[User,Cn_name]),
            Body1 = str:substr(Body,size(Cn_name)+2,size(Body) - 1 - size(Cn_name)),
            Body2 = 
                case catch str:left(Body1,1) of
                <<" ">> ->
                    str:substr(Body1,2,size(Body1));
                <<",">> ->
                    str:substr(Body1,2,size(Body1));
                _ ->
                    Body1
                end,
            Packet = qtalk_public:make_message_packet(<<"subscription">>,Body2,<<"">>,<<"1">>),
            catch ejabberd_router:route(jlib:make_jid(Muc,Domain,FUser), 
                              jlib:make_jid(User,UHost,<<"">>),Packet);
        _ ->
            []
        end;
    _ ->
        ok
    end. 


check_rbt_user(Name,Host) ->
    case catch ets:lookup(rbts_map,{Name,Host}) of
    [RM] when is_record(RM,rbts_map)  ->
        RM#rbts_map.en_name;
    _ ->
        case catch ets:lookup(rbt_info,{Name,Host}) of
        [RI] when is_record(RI,rbt_info) ->
           {Name,Host};
        _ ->
            []
        end
    end.
