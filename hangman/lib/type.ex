defmodule Hangman.Type do
  @type state :: :initializing | :won | :good_guess | :bad_guess | :already_use

  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String.t()),
          used: list(String.t())
        }
end
