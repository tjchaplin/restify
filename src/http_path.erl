-module(http_path).
-export([normalize/1]).

normalize(Path) ->
	"/" ++ string:strip(Path,both,$/).