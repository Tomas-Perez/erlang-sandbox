%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 5:40 PM
%%%-------------------------------------------------------------------
-module(translate2).
-author("Tomas").

%% API
-export([handle/2, init/0]).

%%% Funciones para correr translate con el server generico.
init() -> [].

handle({translate, "hola"}, History) ->
  {"hello", ["hola" | History]};

handle({translate, "mundo"}, History) ->
  {"world", ["mundo" | History]};

handle({translate, W}, History) ->
  {"???", [W | History]};

handle({stats}, History) ->
  {History, History};

handle({reset}, History) ->
  {History, []}.

