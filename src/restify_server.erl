-module(restify_server).

-behaviour (gen_server).

-export ([listen/1,get/2,post/2,delete/2,stop/0,loop/2,request_handler/4]).

-export([start_link/0,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
	{ok, []}.

listen(Options) ->
	gen_server:call(?MODULE,{listen, Options}).

get(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'GET',Route,Handler}}).

post(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'POST',Route,Handler}}).

delete(Route,Handler) ->
	gen_server:cast(?MODULE,{add_route, {'DELETE',Route,Handler}}).

stop() ->
	gen_server:cast(?MODULE,stop).

handle_cast(stop,State) ->
	{stop,normal,State};

handle_cast({add_route,{Method,Route,Handler}}, Routes) ->
	NormalizedRoute = normalize_path(Route),
	NewRoute = {Method,NormalizedRoute,Handler},
	UpdatedRoutes = lists:append(Routes,[NewRoute]),
    {noreply, UpdatedRoutes}.

handle_call({listen,[{ip,IP},{port,Port}]},_From, Routes) ->
	Loop = fun (Req) ->
		?MODULE:loop(Req,Routes)
	end,
    Response = mochiweb_http:start([{ip, IP},{port, Port},{loop,Loop}]),
    {reply, Response, Routes}.

loop(Req,Routes) ->
	Path=normalize_path(Req:get(path)),
	Method = Req:get(method),
	request_handler(Method,Path,Req,Routes).

normalize_path(Path) ->
	"/" ++ string:strip(Path,both,$/).

request_handler(_Method,_Path,Req,[]) ->
	Req:respond({501, [], []});
request_handler(Method,Path,Req,[{Method,Path,Handler}|_Tail]) ->
	Handler(Req);
request_handler(Method,Path,Req,[_NonMatch|Tail]) ->
	request_handler(Method,Path,Req,Tail).

handle_info(_Info, State) ->
    {noreply, State}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.    

terminate(_Reason, _State) ->
    ok.