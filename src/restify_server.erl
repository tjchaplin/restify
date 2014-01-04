-module(restify_server).

-export ([start/2,stop/0]).

start(ConnectionOptions,Routes) ->
	Loop = fun(Req) ->
		restify_request_handler:loop(Req,Routes)
	end,
	start_dependencies(),
    mochiweb_http:start([{name,?MODULE}, {loop,Loop} | ConnectionOptions]).

start_dependencies() ->
	dependency_manager:ensure_started(crypto).

stop() ->
	mochiweb_http:stop(?MODULE).