-module(code1).
-export([handle/2]).

handle(Key,Val) ->
  {{Year, Month, Day},{Hour, Minute, Second}} = calendar:universal_time(),
  Time = list_to_binary(io_lib:format("~4..0w-~2..0w-~2..0w ~2..0w:~2..0w:~2..0w", [Year, Month, Day, Hour, Minute, Second])),
  Sql = io_lib:format("INSERT INTO my_table (time, k, v) VALUES (~p, ~p, ~p)",
        [binary_to_list(Time),binary_to_list(Key),binary_to_list(Val)]),
  case mappr:insert(Sql) of
    {ok, Data} ->
      Response = post:response(Key, <<"ok">>, Data);
    {error, Reason} ->
      Response = post:response(Key, <<"error">>, Reason)
  end,
  jsx:encode(Response).