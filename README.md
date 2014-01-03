restify
=======

>An Erlang Application To Create REST Interfaces 

[![Build Status](https://travis-ci.org/tjchaplin/restify.png?branch=master)](https://travis-ci.org/tjchaplin/restify)

# Get Going

```erlang
%start the application
application:start(restify).

%Add a route
restify_server:get("/awesomeoRoute",fun(Req) -> Req:ok({"plain/text","Received Request to /awesomeoRoute"}) end).

%Start Listening for requests
restify_server:listen([{ip,"127.0.0.1"},{port,8888}]).
```

# Add As Rebar Dependency

In your **rebar.config** file:

```
{deps, [{restify, 
			".*",
			{git, "https://github.com/tjchaplin/restify.git"}}
]}.
```

