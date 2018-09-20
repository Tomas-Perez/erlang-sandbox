%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 4:39 PM
%%%-------------------------------------------------------------------
-module(server1).
-author("Tomas").
-export([start/2, rpc/2, swap_code/2]).

loop(Name, Module, State) ->
  receive

    %%% Cambio el modulo del actor, manteniendo el estado,
    %%% actualizando el codigo del actor en runtime, sin
    %%% dar de baja el sistema
    { From, { swap_code, NewModule }} ->
      From ! {Name, ok, ack},
      loop(Name, NewModule, State);

    %%% Si falla la llamada, aviso del error y mantengo el estado viejo, de
    %%% esa manera no corrompo el estado de mi actor.
    { From, Request } ->
      try Module:handle(Request, State) of
        { Response, NewState } ->
          From ! { Name, ok, Response },
          loop(Name, Module, NewState)
      catch
        _: Why ->
          From ! { Name, crash, Why},
          loop(Name, Module, State)
      end
  end.

start(Name, Module) ->
  register(Name, spawn(fun() -> loop(Name, Module, Module:init()) end)).

swap_code(Name, Module) ->
  rpc(Name, { swap_code, Module}).

rpc(Name, Request) ->
  Name ! { self(), Request },
  receive
    { Name, ok, Response } -> Response;
    { Name, crash, Why } -> exit(Why)
  end.