%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Sep 2018 4:42 PM
%%%-------------------------------------------------------------------
-module(translate).
-author("Tomas").

%% API
-export([loop/0]).

loop() -> loop([]).

loop(History) ->
  receive
    { From, {translate, "hola"} } ->
      From ! "hello",
      loop(["hello" | History]);

    { From, {translate, "mundo"} } ->
      From ! "world",
      loop(["world" | History]);

    { From, {stats} } ->
      From ! { ok, History },
      loop(History);

    { From, {reset} } ->
      From ! { ok, History },
      loop([]);

    { From, _ } ->
      From ! { fail,"???" },
      loop(History)
  end.
