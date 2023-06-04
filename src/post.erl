-module(post).
-behaviour(cowboy_handler).
-export([init/2, result_to_json/2, response/3]).

init(Req, State) ->
  Headers = #{
    <<"access-control-allow-origin">> => <<"*">>,
    <<"access-control-allow-methods">> => <<"GET, POST, PUT, DELETE, OPTIONS">>,
    <<"access-control-allow-headers">> => <<"content-type, authorization">>,
    <<"content-type">> => <<"text/plain;charset=utf-8">>
  },
  {ok, Body, Req1} = cowboy_req:read_body(Req),
  ParsedBody = parse_body(binary_to_list(Body)),
  Key = proplists:get_value(<<"key">>, ParsedBody),
  Val = proplists:get_value(<<"val">>, ParsedBody),
  ResponseText = handle_request(Key, Val),
  ResponseBody = iolist_to_binary(ResponseText),
  Resp = cowboy_req:reply(200, Headers, ResponseBody, Req1),
  {ok, Resp, State};
init(_, _) ->
  ok.

handle_request(Key, Val) ->
  code1:handle(Key, Val).

parse_body(Body) ->
  KeyValues = string:tokens(Body, "&"),
  lists:map(fun(KeyValue) ->
    [Key, Value] = string:tokens(KeyValue, "="),
    {unicode:characters_to_binary(Key, utf8, utf8), unicode:characters_to_binary(Value, utf8, utf8)}
            end, KeyValues).

result_to_json(Columns, Rows) ->
  JsonArray = lists:map(fun(Row) -> RowDict = lists:zip(Columns, Row), maps:from_list(RowDict) end, Rows),
  jsx:encode(JsonArray).

response(Id, Type, Data) ->
  #{id => Id, type => Type, data => Data}.