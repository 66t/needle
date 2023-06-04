-module(app_sup).
-behaviour(supervisor).
-export([start/2, init/1]).

-define(HTTP_PORT, 9999).
-define(WEBSOCKET_PORT, 9997).
-define(POOL_SIZE, 8).
-define(MAX_OVERFLOW, 20).

start(_StartType, _StartArgs) ->
  {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),
  {ok, Pid}.

init([]) ->
  P1 = cowboy_router:compile([{'_', [{"/c", post, []}]}]),
  {ok, _} = cowboy:start_clear(http_listener, [{port, ?HTTP_PORT}], #{env => #{dispatch => P1}}),


  P2 = cowboy_router:compile([{'_', [{"/c", ws, []}]}]),
  {ok, _} = cowboy:start_clear(ws_listener, [{port, ?WEBSOCKET_PORT}], #{env => #{dispatch => P2}}),



  PoolOpts = [{name, {local, database_pool}},
    {worker_module, database},
    {size, ?POOL_SIZE},
    {max_overflow, ?MAX_OVERFLOW}],

  PoolSpec = {database_pool, {poolboy, start_link, [PoolOpts]},
    permanent, 5000, worker, [poolboy]},

  Children = [PoolSpec],

  {ok, {{one_for_one, 5, 10}, Children}}.
