defmodule ExMon.PlayerTest do
  use ExUnit.Case

  alias ExMon.Player

  describe("build/4") do
    test "returns a player" do
      expected_player = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "John"
      }

      assert(Player.build("John", :kick, :punch, :heal) == expected_player)
    end
  end
end
