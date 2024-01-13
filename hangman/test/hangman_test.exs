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

  test "record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(MapSet.new(["x", "y"]), game.used)
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "w")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "o")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter thats not in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "r")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "w")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "y")
    assert tally.game_state == :bad_guess
  end

  # hello
  test "can handle a sequence of moves" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "_", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence_of_moves()
  end
  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end
  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end
end
