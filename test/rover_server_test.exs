defmodule RoverServerTest do
  use ExUnit.Case, async: true
  alias RoverOnMars.RoverServer

  describe "When rotate to left" do
    test "Given the rover is facing North, when the rover rotates Left, then the rover is facing West" do
      position = get_rotate(:north, :left)
      assert :west == position
    end

    test "Given the rover is facing West, when the rover rotates Left, then the rover is facing South" do
      position = get_rotate(:west, :left)
      assert :south == position
    end

    test "Given the rover is facing South, when the rover rotates Left, then the rover is facing East" do
      position = get_rotate(:south, :left)
      assert :east == position
    end

    test "Given the rover is facing East, when the rover rotates Left, then the rover is facing North" do
      position = get_rotate(:east, :left)
      assert :north == position
    end
  end

  describe "When rotate to right" do
    test "Given the rover is facing North, when the rover rotates Right, then the rover is facing East" do
      position = get_rotate(:north, :right)
      assert :east == position
    end

    test "Given the rover is facing East, when the rover rotates Right, then the rover is facing South" do
      position = get_rotate(:east, :right)
      assert :south == position
    end

    test "Given the rover is facing South, when the rover rotates Right, then the rover is facing West" do
      position = get_rotate(:south, :right)
      assert :west == position
    end

    test "Given the rover is facing West, when the rover rotates Right, then the rover is facing North" do
      position = get_rotate(:west, :right)
      assert :north == position
    end
  end

  describe "When move forward" do
    test "Given the Is as position 1,1 and the rover is facing North, when the rover moves forward, the rover is in position 0,1" do
      current_position = get_position(:north, [0, 1])
      assert [0, 1] == current_position
    end

    test "Given the Rover is facing West and is at position(0,0), when the user tries to move forward, the rovers position does not change" do
      current_position = get_position(:west, [0, 0])
      assert [0, 0] == current_position
    end

    test "Given the Rover is facing North and is at position(0,0), when the user tries to move forward, the rovers position does not change" do
      current_position = get_position(:north, [0, 0])
      assert [0, 0] == current_position
    end

    test "Given the Rover is facing South and is at position(3,0), when the user tries to move forward, the rovers position does not change" do
      current_position = get_position(:south, [3, 0])
      assert [3, 0] == current_position
    end

    test "Given the Rover is facing East and is at position(0,3), when the user tries to move forward, the rovers position does not change" do
      current_position = get_position(:east, [0, 3])
      assert [0, 3] == current_position
    end
  end

  describe "When get state" do
    test "Given the Rover is at position 1,1 and facing North, when the rover moves forward, get state should be { :north, [0,1] }" do
      RoverServer.start_link(:north, [1, 1])
      RoverServer.move()
      state = RoverServer.get_state()
      # Process.exit(pid, :kill)
      {facing_to, position} = state

      assert :north == facing_to
      assert [0, 1] == position
    end
  end

  defp get_rotate(init_diretion, diretion_to_rotate) do
    {:ok, pid} = RoverServer.start_link(init_diretion, [0, 0])
    position = RoverServer.rotate_to(diretion_to_rotate)
    Process.exit(pid, :kill)
    position
  end

  defp get_position(movimento_to, init_state) do
    {:ok, pid} = RoverServer.start_link(movimento_to, init_state)
    current_position = RoverServer.move()
    Process.exit(pid, :kill)
    current_position
  end
end
