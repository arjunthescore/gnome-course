defmodule TextClient.Impl.Player do
  @typep game :: Hangman.game()
  @typep tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  # @type state :: :initializing | :won | :good_guess | :bad_guess | :already_use
  @spec interact(state) :: :ok

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations, you've won!!!")
  end

  def interact({game, _tally = %{game_state: :lost}}) do
    IO.puts("Better luck next time, you've lost. Word: #{game.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    Hangman.make_move(game, get_guess())
    |> interact()
  end

  # @type state :: :initializing | :won | :good_guess | :bad_guess | :already_use

  defp feedback_for(tally = %{game_state: :initializing}) do
    "I'm thinking of a #{tally.letters |> length} letter word"
  end

  defp feedback_for(_tally = %{game_state: :good_guess}) do
    "Good guess!"
  end

  defp feedback_for(_tally = %{game_state: :bad_guess}) do
    "Sorry that letter is not in the word"
  end

  defp feedback_for(_tally = %{game_state: :already_use}) do
    "Sorry you've already used that letter"
  end

  defp get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end

  def current_word(tally) do
    [
      "Word, so far:",
      tally.letters |> Enum.join(" "),
      "   turns left: ",
      tally.turns_left |> to_string,
      "   used so far: ",
      tally.used |> Enum.join(",")
    ]
  end
end
