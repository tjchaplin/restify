-module(restify_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.

start(_StartType, _StartArgs) ->
	ensure_started(crypto),
    restify_sup:start_link().

stop(_State) ->
    ok.
