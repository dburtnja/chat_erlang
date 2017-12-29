-module(test_erl_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
	Disp = cowboy_router:compile([
		{
			'_',
			[
				{"/", cowboy_static, {priv_file, test_erl, "static/index.html"}},
				{"/connect", my_handler, []},
				{"/[...]", cowboy_static, {priv_dir, test_erl, "static/"}}
			]
		}
	]),
	{ok, _} = cowboy:start_clear(my_http_listener,
		[{port, 8080}],
		#{env => #{dispatch => Disp}}
	),
	test_erl_sup:start_link().

stop(_State) ->
	ok.
