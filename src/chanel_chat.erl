-module(chanel_chat).
-behavior(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, State) ->
	reg:start(chat),
	{cowboy_websocket, Req, State}.

websocket_init(State) ->
	chat ! {self(), add},
	{reply, {binary, term_to_binary(pid_to_list(self()))}, State}.

websocket_handle({text, <<"here">>}, State) ->
	{reply, {binary, term_to_binary("ok")}, State};
websocket_handle({binary, Data}, State) ->
	{msg, Msg} = binary_to_term(Data),
	chat ! {self(), foreach, fun(E) -> E ! Msg end},
	{ok, State};
websocket_handle(_Frame, State) ->
	{ok, State}.

websocket_info(Data, State) ->
	Reply = {binary, term_to_binary(Data)},
	{reply, Reply, State}.

