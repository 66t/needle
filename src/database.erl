-module(database).
-behaviour(poolboy_worker).
-export([start_link/1, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(MYSQL_HOST, "localhost").
-define(MYSQL_PORT, 3306).
-define(MYSQL_USER, "root").
-define(MYSQL_PASSWORD, "myonmyon~").
-define(MYSQL_DATABASE, "wiki").

start_link(_Args) ->
  gen_server:start_link(?MODULE, [], []).

init([]) ->
  {ok, Pid} = connect(),
  {ok, Pid}.

handle_call({query, Sql}, _From, State) ->
  case mysql:query(State, Sql) of
    {ok, Columns, Rows} ->
      {reply, {ok, {Columns, Rows}}, State};
    {error, Reason} ->
      {reply, {error, Reason}, State}
  end;
handle_call({insert, Sql}, _From, State) ->
  case mysql:query(State, Sql) of
    ok ->
      {reply, {ok, <<"Insert successful.">>}, State};
    {error, Reason} ->
      {reply, {error, Reason}, State}
  end;

handle_call({update, Sql}, _From, State) ->
  case mysql:query(State, Sql) of
    {ok} ->
      {reply, {ok, <<"Update successful.">>}, State};
    {error, Reason} ->
      {reply, {error, Reason}, State}
  end.


handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

connect() ->
  mysql:start_link(
    [{host, ?MYSQL_HOST},
      {port, ?MYSQL_PORT},
      {user, ?MYSQL_USER},
      {password, ?MYSQL_PASSWORD},
      {database, ?MYSQL_DATABASE}]
  ).
