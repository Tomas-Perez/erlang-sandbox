%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Sep 2018 5:53 PM
%%%-------------------------------------------------------------------
-module(translate3).
-author("Tomas").

%% API
-export([init/0, handle/2]).

%%% Otra implementacion para probar swap_code
init() -> [].

handle({translate, "hola"}, History) ->
  {"hello", ["hola" | History]};

handle({translate, "mundo"}, History) ->
  {"world", ["mundo" | History]};

handle({translate, "servidor"}, History) ->
  {"server", ["servidor" | History]};

handle({translate, W}, History) ->
  {"?", [W | History]};

handle({stats}, History) ->
  {History, History};

handle({reset}, History) ->
  {History, History}.