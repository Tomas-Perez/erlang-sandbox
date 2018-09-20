%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. Sep 2018 5:21 PM
%%%-------------------------------------------------------------------
-module(asynclist).
-author("Tomas").

%% API
-export([loop/0]).

loop() -> loop([]).

loop(List) ->
  receive
    {From, {store, Item} }->
      From ! {self(), ok},
      loop([Item | List]);

    {From, {take, Item} } ->
      case lists:member(Item, List) of
        true ->
          From ! {self(), ok},
          loop(lists:delete(Item, List));
        false ->
          From ! {self(), not_found},
          loop(List)
      end;

    {From, {list}} ->
      From ! {self(), {ok, List}},
      loop(List);

    {From, terminate} ->
      From ! ok
  end.
