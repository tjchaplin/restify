-module(restify_dev).
-export([start/0, stop/0]).

start() ->
    dependency_manager:ensure_started(crypto).

stop() ->
    ok.