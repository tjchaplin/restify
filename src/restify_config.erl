-module(restify_config).

-behaviour (gen_server).

-export ([get/2,post/2,delete/2,routes/0]).

-export([start_link/0,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	{ok, []}.

get(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'GET',Route,Handler}}).

post(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'POST',Route,Handler}}).

delete(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'DELETE',Route,Handler}}).

routes() ->
	gen_server:call(?MODULE,{routes}).

stop() ->
	gen_server:cast(?MODULE,stop).

handle_cast(stop,State) ->
	{stop,normal,State};

handle_cast({add_route,{Method,Route,Handler}}, Routes) ->
	NormalizedRoute = normalize_path(Route),
	NewRoute = {Method,NormalizedRoute,Handler},
	UpdatedRoutes = lists:append(Routes,[NewRoute]),
    {noreply, UpdatedRoutes}.

handle_call({routes},_From, Routes) ->
    {reply, Routes, Routes}.

normalize_path(Path) ->
	"/" ++ string:strip(Path,both,$/).

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.    

terminate(_Reason, _State) ->
    ok.