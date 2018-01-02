%%%-------------------------------------------------------------------
%%% @author ezburde
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. груд 2017 9:41
%%%-------------------------------------------------------------------
-module(reg).
-author("ezburde").

%% API
-export([start/1, my_receive/0, test_pocess/0]).

start(Name) ->
  Result = whereis(Name),
  if
    Result =:= undefined ->
      Pid = spawn(fun() -> loop([]) end),
      register(Name, Pid);
    true -> ok
  end.

loop(Reg) ->
  receive
    {Sender, add} ->
      NewReg = [Sender] ++ Reg,
      loop(NewReg);
    {Sender, get} ->
      Fun = fun(E) -> is_process_alive(E) end,
      List = lists:filter(Fun, Reg),
      Rest = get_processing(Sender, List),
      loop(Rest);
    {Sender, all} ->
      Fun = fun(E) -> is_process_alive(E) end,
      List = lists:filter(Fun, Reg),
      Sender ! {users, List},
      loop(List);
    {Sender, foreach, Fun} ->
      List = lists:filter(fun(E) -> is_process_alive(E) end, Reg),
      lists:foreach(Fun, List),
      loop(List)
  end.

get_processing(Sender, []) ->
  Sender ! {user, empty},
  [];
get_processing(Sender, [First | Rest]) ->
  Sender ! {user, First},
  Rest.



my_receive() ->
  receive
    Eny -> Eny
  after 6000 ->
    no
  end.

test_pocess() ->
  spawn(fun() -> receive die -> ok end end).
