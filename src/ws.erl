-module(ws).
-behaviour(cowboy_handler).
-export([init/2,websocket_handle/2]).

init(Req, State) ->
  io:format("websocket~n"),
  {cowboy_websocket, Req, State}.

websocket_handle(Data, Req) ->
  io:format("Received WebSocket message: ~p~n", [Data]),
  {ok, Req}.
