%%%-------------------------------------------------------------------
%%% @author Toto
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dec 2018 5:29 PM
%%%-------------------------------------------------------------------
-module(server).
-author("Toto").

%% API
-export([swap_code/2, rpc/2, start/3]).

loop(Name, Module, State) ->
  receive
    {From, Request} ->
      try Module:handle(Request, State) of
        {Response, NewState} ->
          From ! {Name, ok, Response},
          loop(Name, Module, NewState)
      catch
        _: Why ->
          From ! {Name, crash, Why},
          loop(Name, Module, State)
      end;

    {From, {swap_code, NewModule}} ->
      From ! {Name, ok, ack},
      loop(Name, NewModule, State)

  end.

start(Name, Module, Args) ->
  register(Name, spawn(fun() -> loop(Name, Module, Module:init(Args)) end)).

swap_code(Name, NewModule) ->
  rpc(Name, {swap_code, NewModule}).

rpc(Name, Request) ->
  Name ! {self(), Request},
  receive
    {Name, ok, Response} -> Response;
    {Name, crash, Why} -> exit(Why)
  end.
