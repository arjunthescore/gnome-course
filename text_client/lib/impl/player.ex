defmodule Impl.Player do
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end
  #@type state :: :initializing | :won | :good_guess | :bad_guess | :already_use
  @spec interact(state) :: :ok
  def interact(state) do

  end

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations, you've won!!!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Better luck next time, you've lost: #{tally.letters |> Enum.join()}")
  end
end
