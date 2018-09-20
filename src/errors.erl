%%%-------------------------------------------------------------------
%%% @author Tomas
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Sep 2018 5:35 PM
%%%-------------------------------------------------------------------
-module(errors).
-author("Tomas").
-compile(export_all).

f(N) ->
  timer:sleep(2500),
  io:format("Running step ~p~n", [N]),
  10 / N,
  f(N - 1).

%%% on exit
%%% recibe un proceso y una funcion
%%% crea un actor, en el caso que se produzca un exit, atrapalo
%%% link monitorea un actor, si uno muere, el otro también
%%% al hacer el link, recibo el exit del otro proceso como un mensaje
%%% al recibir el EXIT, llama a la funcion que me pasaron como parametro

on_exit(Pid, Fun) ->
  spawn(fun() ->
    process_flag(trap_exit, true),
    link(Pid),
    receive
      {'EXIT', Pid, Why} -> Fun(Why)
    end
  end).

%%% keep_alive
%%% recibe nombre de proceso y funcion
%%% lanza un proceso y lo mantiene siempre vivo
%%% register: un mapa mutable
%%% en el on_exit, llama a keep_alive denuevo, crea otro proceso de reemplazo
%%% registra el PID del proceso creado, bajo el mismo nombre, para que se
%%% pueda seguir usando.

keep_alive(Name, F) ->
  register(Name, Pid = spawn(F)),
  on_exit(Pid, fun(_Why) -> keep_alive(Name, F) end).





