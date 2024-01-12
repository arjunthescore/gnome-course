defmodule HangmanTest do
  alias Hangman.Impl.Game
  use ExUnit.Case
  doctest Hangman

  test "new game returns a structure" do
    game = Game.new_game("wombat")
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "letters are all lower case" do
    game_1 = Game.new_game("wombat")
    game_2 = Game.new_game("WomBat")
    assert Enum.all?(game_1.letters, fn x -> String.downcase(x) == x end) == true
    assert Enum.all?(game_2.letters, fn x -> String.downcase(x) == x end) == false
  end

  test "state doesn't change if game is won" do
    game =
      Game.new_game("wombat")
      |> Map.put(:game_state, :won)

    {new_game, _tally} = Game.make_move(game, "x")
    assert game == new_game
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
end
