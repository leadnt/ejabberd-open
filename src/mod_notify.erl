-module(mod_notify).

-behaviour(gen_mod).

-export([start/2, stop/1, process_presence_in/2,
	 mod_opt_type/1, depends/2]).

-include("ejabberd.hrl").
-include("logger.hrl").

-include("jlib.hrl").


start(Host, _Opts) ->
    ejabberd_hooks:add(c2s_presence_in, Host, ?MODULE,
		       process_presence_in, 100).

stop(Host) ->
    ejabberd_hooks:delete(c2s_presence_in, Host,
			  ?MODULE, process_presence_in, 100).

process_presence_in(C2SState, {From, To,  #xmlel{attrs = Attrs} = Packet}) ->
    Category = fxml:get_attr_s(<<"category">>, Attrs),
    case fxml:get_attr_s(<<"type">>, Attrs) of
        <<"notify">> -> do_process_presence(From, To, Packet, Category);
        _ -> ok
    end,
    C2SState.

do_process_presence(From, To, Packet, Category) when Category =:= <<"3">>; Category == <<"9">> ->
    ok;
do_process_presence(From, To, Packet, _) ->
    Now = qtalk_public:get_exact_timestamp(),
    Content = rfc4627:encode({obj, [{"from", From#jid.luser},
                                    {"to", To#jid.luser},
                                    {"fromhost", From#jid.lserver},
                                    {"tohost", To#jid.lserver},
                                    {"time", integer_to_binary(Now)},
                                    {"body", fxml:element_to_binary(Packet)}]}),
    catch spawn(send_kafka_msg,send_kafka_msg,[<<"custom_vs_hosts_special_message">>, <<"notifyPresence">>, Content]).

depends(_Host, _Opts) ->
    [].

mod_opt_type(_) -> [].
