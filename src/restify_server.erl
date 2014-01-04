-module(restify_server).

-export ([start/2,stop/0,loop/2,request_handler/4]).

start([{ip,IP},{port,Port}],Routes) ->
	Loop = fun(Req) ->
		?MODULE:loop(Req,Routes)
	end,
    mochiweb_http:start([{name,?MODULE},{ip, IP},{port, Port},{loop,Loop}]).

stop() ->
	mochiweb_http:stop(?MODULE).

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