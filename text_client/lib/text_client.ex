defmodule TextClient do
  alias TextClient.Impl.Player
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: {game, tally}
  @spec start() :: :ok
  defdelegate start, to: Player

  @spec interact(state) :: :ok
  defdelegate interact(state), to: Player
end
