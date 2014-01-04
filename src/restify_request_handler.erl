-module(restify_request_handler).

-export ([loop/2]).

loop(Req,Routes) ->
	Path=http_path:normalize(Req:get(path)),
	Method = Req:get(method),
	request_parser(Method,Path,Req,Routes).

request_parser(_Method,_Path,Req,[]) ->
	Req:respond({501, [], []});
request_parser(Method,Path,Req,[{Method,Path,Handler}|_Tail]) ->
	Handler(Req);
request_parser(Method,Path,Req,[_NonMatch|Tail]) ->
	request_parser(Method,Path,Req,Tail).