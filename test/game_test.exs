defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)

      assert({:ok, _pid} = Game.start(computer, player))
    end
  end

  describe "info/0" do
    test "returnsthe current game state" do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_game_info = %{
        computer: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Doe"
        },
        player: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "John"
        },
        status: :started,
        turn: :player
      }

      assert(Game.info() == expected_game_info)
    end
  end

  describe "update/1" do
    test "update the game state" do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)
      Game.start(computer, player)

      new_game_info = %{
        computer: %ExMon.Player{
          life: 80,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Doe"
        },
        player: %ExMon.Player{
          life: 73,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "John"
        },
        status: :continue,
        turn: :player
      }

      Game.update(new_game_info)
      expected_game_info = %{new_game_info | turn: :computer, status: :continue}

      assert(Game.info() == expected_game_info)
    end
  end

  describe "player/0" do
    test "returns correct player info" do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)
      Game.start(computer, player)

      assert(Game.player() == player)
    end
  end

  describe "turn/0" do
    test "returns correct turn info" do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)
      Game.start(computer, player)

      assert(Game.turn() == :player)
    end
  end
end
