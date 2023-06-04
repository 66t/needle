-module(mappr).
-export([query/1,insert/1,update/1]).

query(Sql) ->
  Pid = poolboy:checkout(database_pool),
  Result = gen_server:call(Pid, {query, Sql}),
  poolboy:checkin(database_pool, Pid),
  io:format(Result),
  Result.

insert(Sql) ->
  Pid = poolboy:checkout(database_pool),
  Result = gen_server:call(Pid, {insert, Sql}),
  poolboy:checkin(database_pool, Pid),
  Result.

update(Sql) ->
  Pid = poolboy:checkout(database_pool),
  Result = gen_server:call(Pid, {update, Sql}),
  poolboy:checkin(database_pool, Pid),
  Result.