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

## Add As Rebar Dependency

In your **rebar.config** file:

```
{deps, [{restify, 
			".*",
			{git, "https://github.com/tjchaplin/restify.git"}}
]}.
```

# Dependencies

The library uses [mochiweb](https://github.com/mochi/mochiweb) as its lightweight webserver.