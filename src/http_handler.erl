-module(http_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req, State) ->
	RespText =
		case cowboy_req:parse_qs(Req) of
			[{<<"name">>, Name}] ->
				binary_to_list(Name) ++ pid_to_list(self());
			_Else ->
				"No name"
		end,
	Resp = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>},
		RespText,
		Req),
	{ok, Resp, State}.

