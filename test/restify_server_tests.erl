-module(restify_server_tests).

-include_lib("eunit/include/eunit.hrl").

setup([{ip,IP},{port,Port}]) ->
	inets:start(),
	application:start(crypto),
	restify_server:start_link(),
	restify_server:get("/test",fun(Req) -> testHandler(Req) end),
	restify_server:listen([{ip,IP},{port,Port}]).

teardown(_) ->
	inets:stop(),
	restify_server:stop().

testHandler(Req) ->
	Req:ok({"text/plain", "Test Request"}).

given_a_connection_test_() ->
	Port = 8888,
	IP = "127.0.0.1",
	{setup, 
		fun() -> setup([{ip,IP},{port,Port}]) end, 
		fun teardown/1, 
		fun(_Url) ->
			{inparallel,
			[
			 when_doesnt_have_trailing_slash_then_response_body_will_be_returned(),
			 when_doesnt_have_trailing_slash_then_response_status_code_will_be_200(),
			 when_has_trailing_slash_then_response_body_will_be_returned(),
			 when_has_trailing_slash_then_response_response_status_code_will_be_200()
			 ]}
		end}.

when_doesnt_have_trailing_slash_then_response_body_will_be_returned() ->
	Url = "http://localhost:8888/test",
	{ok, {{_Version, _StatusCode, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {Url,[]}, [], []),
	?_assert(Body =:= "Test Request").

when_doesnt_have_trailing_slash_then_response_status_code_will_be_200() ->
	Url = "http://localhost:8888/test",
	{ok, {{_Version, StatusCode, _ReasonPhrase}, _Headers, _Body}} = httpc:request(get, {Url,[]}, [], []),
	?_assert(StatusCode =:= 200).

when_has_trailing_slash_then_response_body_will_be_returned() ->
	Url = "http://localhost:8888/test/",
	{ok, {{_Version, _StatusCode, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {Url,[]}, [], []),
	?_assert(Body =:= "Test Request").

when_has_trailing_slash_then_response_response_status_code_will_be_200() ->
	Url = "http://localhost:8888/test/",
	{ok, {{_Version, StatusCode, _ReasonPhrase}, _Headers, _Body}} = httpc:request(get, {Url,[]}, [], []),
	?_assert(StatusCode =:= 200).
