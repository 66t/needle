-module(code101).
-export([handle/1]).

handle(Val) ->
  Sql = "SELECT * FROM mv",
  case mappr:query(Sql) of
    {ok, {Columns, Rows}} ->
      Json = post:result_to_json(Columns, Rows),
      Response = post:response(101, <<"ok">>, Json);
    {error, Reason} ->
      Response = post:response(101, <<"error">>, <<"[]">>)
  end,
  jsx:encode(Response).