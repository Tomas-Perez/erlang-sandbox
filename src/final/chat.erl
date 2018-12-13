%%%-------------------------------------------------------------------
%%% @author Toto
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. Dec 2018 4:08 PM
%%%-------------------------------------------------------------------
-module(chat).
-author("Toto").

%% API
-export([chat/0, chatMember/1]).

chat() -> chat(maps:new()).

chat(Members) ->
  receive

    {From, {join, Name}} ->
      From ! {self(), ok},
      chat(Members#{From => Name});

    {From, {send_message, Msg}} ->
      case maps:find(From, Members) of
        {ok, Name} ->
          lists:foreach(fun(Member) ->
            Member ! { self(), { new_message, {Name, Msg} } }
                        end, maps:keys(Members))
      end,
      chat(Members);

    {From, leave} ->
      From ! {self(), ok},
      chat(maps:without(From, Members))

  end.

chatMember(Name) -> chatMember(Name, nothing, []).

chatMember(Name, Room, History) ->
  receive

    {From, {join, NewRoom}} ->
      From ! {self(), ok},
      NewRoom ! {self(), {join, Name}},
      if
        Room /= nothing ->
          Room ! {self(), leave},
          chatMember(Name, NewRoom, History);
        true ->
          chatMember(Name, NewRoom, History)
      end;


    {From, {send_message, Msg}} ->
      if
        Room /= nothing ->
          From ! {self(), ok},
          Room ! {self(), {send_message, Msg}};
        true ->
          From ! {self(), no_room}
      end,
      chatMember(Name, Room, History);

    {From, leave} ->
      if
        Room /= nothing ->
          From ! {self(), ok},
          Room ! {self(), leave};
        true ->
          From ! {self(), ok}
      end,
      chatMember(Name, nothing, []);

    {From, get_history} ->
      From ! {self(), {ok, History}},
      chatMember(Name, Room, History);

    {From, {new_message, MsgTuple}} ->
      From ! {self(), ok},
      chatMember(Name, Room, [MsgTuple | History])

  end.
