defmodule ExMon.Game.StatusTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  alias ExMon.Game.Status

  describe "print_round_message\1" do
    setup do
      player = Player.build("John", :kick, :punch, :heal)
      computer = Player.build("Doe", :kick, :punch, :heal)

      capture_io(fn ->
        Game.start(computer, player)
      end)

      :ok
    end

    test "when game starts returns the correct round message" do
      messages =
        capture_io(fn ->
          Status.print_round_message(Game.info())
        end)

      assert(messages =~ "The game is started!")
      assert(messages =~ "status: :started")
    end

    test "when game are started returns the correct round message" do
      capture_io(fn ->
        ExMon.make_move(:kick)
      end)

      messages =
        capture_io(fn ->
          Status.print_round_message(Game.info())
        end)

      player =
        Game.info()
        |> Map.get(:turn)

      assert(messages =~ "It's #{player} turn.")
      assert(messages =~ "status: :continue")
    end

    test "when game are finished returns the correct round message" do
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
          Status.print_round_message(Game.info())
        end)

      assert(messages =~ "The game is over.")
      assert(messages =~ "status: :game_over")
    end

    test "when move is a wrong move" do
      messages =
        capture_io(fn ->
          Status.print_wrong_move(:wrong)
        end)

      assert(messages =~ "Invalid move: wrong")
    end

    test "when move is a valid attack move" do
      messages =
        capture_io(fn ->
          Status.print_move_message(:computer, :attack, 20)
        end)

      assert(messages =~ "The Player attacked the computer dealing 20 damage")
    end

    test "when move is a valid heal move" do
      messages =
        capture_io(fn ->
          Status.print_move_message(:player, :heal, 20)
        end)

      assert(messages =~ "The player healed itself to 20 life points.")
    end
  end
end
