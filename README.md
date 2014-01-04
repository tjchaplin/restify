restify
=======

>An Erlang Library For REST Interfaces

[![Build Status](https://travis-ci.org/tjchaplin/restify.png?branch=master)](https://travis-ci.org/tjchaplin/restify)

# Get Going

```erlang
%Specify routes:[{Method:atom(),Route:string(),Handler:fun()}]
Routes=[{'GET',
		 "/awesomeoRoute",
		 fun(Req) -> Req:ok({"plain/text","Received Request to awesomeoRoute"}) end
		}].

%Specify mochiweb server options
Options = [{ip,"127.0.0.1"},{port,8888}].

%Start Listening and responding to requests
restify_server:start(Options,Routes).
```

# Purpose

A library to make the creation of rest interfaces easier in erlang.  To allow developers to focus on the implementation of the API, not the details of setting up the webserver.

# Building

##Windows

1. Get the [restify](https://github.com/tjchaplin/restify) source from GitHub
2. Open the command prompt
3. Cd into the directory
4. Ensure [rebar](https://github.com/rebar/rebar) is in your Path so that you can execute commands
5. Execute rebar command

```
$ rebar get-deps compile
```

##Unix

1. Get the [restify](https://github.com/tjchaplin/restify) source from GitHub
2. Cd into the directory
3. Make it

```
$ make
```
The library uses [mochiweb](https://github.com/mochi/mochiweb) as its lightweight webserver.

# Usages

To use this library in an OTP application it needs to be added to the supervision tree.  The best way to to this is as follows

1. Add As Rebar Dependency

In your **rebar.config** file:

```
{deps, [{restify, 
			".*",
			{git, "https://github.com/tjchaplin/restify.git"}}
]}.
```

2. Create a module that will setup the rest server

rest_server.erl
```erlang
-module(rest_server).

-export ([start_link/0]).

start_link() ->
	%Specify routes:[{Method:atom(),Route:string(),Handler:fun()}]
	Routes=[{'GET',
			 "/awesomeoRoute",
			 fun(Req) -> Req:ok({"plain/text","Received Request to awesomeoRoute"}) end
			}],
	
	%Specify mochiweb server options
	Options = [{ip,"127.0.0.1"},{port,8888}],

	%Start Listening for requests.
	%Note: this will return a PID for the supervisior to monitor
	restify_server:start(Options,Routes).
```

3. Add the *rest_server* as a worker to the appliction supervisor

myapp_sup.erl

```erlang
-module(myapp_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    RestServer={rest_server, 
    				{rest_server, start_link, []},
    				permanent, 5000, worker, dynamic},
	SupervisorChildren =[RestServer],
    {ok, { {one_for_one, 5, 10}, Children} }.
```

4. Now when your OTP application is started the rest_server(restify) will be monitored

# Dependencies

The library uses [mochiweb](https://github.com/mochi/mochiweb) as its lightweight webserver.