defmodule ExMonTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}

  describe("create_player/4") do
    test "returns a player" do
      expected_player = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "John"
      }

      assert(ExMon.create_player("John", :kick, :punch, :heal) == expected_player)
    end
  end

  describe("start_game/1") do
    test "starts the game" do
      player = Player.build("John", :kick, :punch, :heal)

      messages =
        capture_io(fn ->
          assert(ExMon.start_game(player) == :ok)
        end)

      assert(messages =~ "The game is started!")
      assert(messages =~ "status: :started")
      assert(messages =~ "turn: :player")
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("John", :kick, :punch, :heal)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, do the move and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      assert(messages =~ "The Player attacked the computer")
      assert(messages =~ "It's computer turn")
      assert(messages =~ "It's player turn")
      assert(messages =~ "status: :continue")
    end

    test "when the move is invalid" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:wrong_move)
        end)

      assert(messages =~ "Invalid move: wrong_move")
    end

    test "when the status is game over" do
      new_game_info = %{
        computer: %Player{
          life: 0,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Doe"
        },
        player: %Player{
          life: 73,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "John"
        },
        status: :game_over,
        turn: :player
      }

      Game.update(new_game_info)

      messages =
        capture_io(fn ->
          ExMon.make_move(:kick)
        end)

      assert(messages =~ "The game is over.")
    end
  end
end
