-module(send_kafka_msg).

-include("logger.hrl").

-export([send_kafka_msg/3]).

send_kafka_msg(Topic, Key, Content) ->
    %%kafka_producer:send_message(Topic, Key, Content).
    ok.
