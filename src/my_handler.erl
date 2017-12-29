-module(my_handler).
-behavior(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, State) ->
	reg:start(my_reg),
	{cowboy_websocket, Req, State}.

websocket_init(State) ->
	my_reg ! {self(), get},
	Reply = {binary, term_to_binary({my_pid, pid_to_list(self())})},
	{reply, Reply, State}.

websocket_handle({text, <<"here">>}, State) ->
	Reply = {binary, term_to_binary({ok, pid_to_list(self())})},
	{reply, Reply, State};
websocket_handle({binary, Data}, State) ->
	Reply = help_websocket_handler(binary_to_term(Data)),
	{reply, Reply, State};
websocket_handle(_Frame, State) ->
	{ok, State}.

help_websocket_handler([<<"to">>, PidStr, Msg]) ->
	list_to_pid(binary_to_list(PidStr))!{from, self(), binary_to_list(Msg)},
	{binary, term_to_binary({to, PidStr, Msg, pid_to_list(self())})};
help_websocket_handler([<<"hi">>, PidStr]) ->
	list_to_pid(binary_to_list(PidStr)) ! {user, self()},
	{binary, term_to_binary("connect")}.

websocket_info({from, Pid, Msg}, State) ->
	Reply = {binary, term_to_binary({from, pid_to_list(Pid), Msg})},
	{reply, Reply, State};
websocket_info({user, empty}, State) ->
	my_reg ! {self(), add},
	Reply = {binary, term_to_binary({users, empty})},
	{reply, Reply, State};
websocket_info({user, User}, State) ->
	Reply = {binary, term_to_binary({users, pid_to_list(User)})},
	{reply, Reply, State};
websocket_info(_Info, State) ->
	{ok, State}.