defmodule TextClient do
  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: {game, tally}
  alias TextClient.Impl.Player
  @spec start() :: :ok
  defdelegate start, to: Player

  @spec interact(state) :: :ok
  def interact(state) do

  end
end
