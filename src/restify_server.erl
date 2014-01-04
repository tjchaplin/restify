-module(restify_server).

-export ([start/2,stop/0]).

start(ConnectionOptions,Routes) ->
	Loop = fun(Req) ->
		restify_request_handler:loop(Req,Routes)
	end,
    mochiweb_http:start([{name,?MODULE}, {loop,Loop} | ConnectionOptions]).

stop() ->
	mochiweb_http:stop(?MODULE).