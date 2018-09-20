%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Sep 2018 1:02 PM
%%%-------------------------------------------------------------------
-module(test).
-author("Tomas").

%% API
-export([fact/1, hello_world/0, fact2/1]).

%%% The result is actually calculated on the return of the last call,
%%% so the program has to maintain a stack to save the N value on each call
%%% and the next function call.

fact(N) when N>0 -> N * fact(N-1);
fact(0) -> 1.

%%% Tail recursion optimization
%%%
%%% By calling the next function with the value already calculated,
%%% there's no need to save the N value, and the compiler can optimize
%%% the function calls as a simple counter, instead of a stack in memory.

fact2(N) -> fact2(N, 1).

fact2(0, Acc) -> Acc;
fact2(N, Acc) when N > 0 -> fact2(N - 1, N * Acc).


hello_world() ->
  io:fwrite("hello, world\n"),
  io:fwrite("~B", [fact(3)]).
