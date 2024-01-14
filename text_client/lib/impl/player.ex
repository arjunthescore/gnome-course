defmodule TextClient.Impl.Player do
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

  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts "Congratulations, you've won!!!"
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Better luck next time, you've lost. Correct answer: #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts feedback_for(tally)
    IO.puts tally.letters |> Enum.join()
    guess = IO.gets("Please enter your next guess:\n")
    Hangman.make_move(game, guess)
    |> interact()
  end

  #@type state :: :initializing | :won | :good_guess | :bad_guess | :already_use


  defp feedback_for(tally = %{game: :intialized}) do
    "I'm thinking of a #{tally.letters |> length} word"
  end
  defp feedback_for(_tally = %{game: :good_guess}) do
    "Good guess!"
  end
  defp feedback_for(_tally = %{game: :bad_guess}) do
    "Sorry that letter is not in the word"
  end
  defp feedback_for(_tally = %{game: :already_use}) do
    "Sorry you've already used that letter"
  end
end
