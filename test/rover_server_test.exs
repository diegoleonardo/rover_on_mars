defmodule RoverServerTest do
  use ExUnit.Case, async: true
  alias RoverOnMars.RoverServer

  describe "When rotate to left" do
    test "Given the rover is facing North, when the rover rotates Left, then the rover is facing West" do
      position = RoverServer.rotate_to({:left, :north})
      assert :west == position
    end

    test "Given the rover is facing West, when the rover rotates Left, then the rover is facing South" do
      position = RoverServer.rotate_to({:left, :west})
      assert :south == position
    end

    test "Given the rover is facing South, when the rover rotates Left, then the rover is facing East" do
      position = RoverServer.rotate_to({:left, :south})
      assert :east == position
    end

    test "Given the rover is facing East, when the rover rotates Left, then the rover is facing North" do
      position = RoverServer.rotate_to({:left, :east})
      assert :north == position
    end
  end

  describe "When rotate to right" do
    test "Given the rover is facing North, when the rover rotates Right, then the rover is facing East" do
      position = RoverServer.rotate_to({:right, :north})
      assert :east == position
    end

    test "Given the rover is facing East, when the rover rotates Right, then the rover is facing South" do
      position = RoverServer.rotate_to({:right, :east})
      assert :south == position
    end

    test "Given the rover is facing South, when the rover rotates Right, then the rover is facing West" do
      position = RoverServer.rotate_to({:right, :south})
      assert :west == position
    end

    test "Given the rover is facing West, when the rover rotates Right, then the rover is facing North" do
      position = RoverServer.rotate_to({:right, :west})
      assert :north == position
    end
  end

  describe "When move forward" do
    test "Given the Is as position 1,1 and the rover is facing North, when the rover moves forward, the rover is in position 0,1" do
      current_position = RoverServer.move_to({:north, [1, 1]})
      assert [0, 1] == current_position
    end

    test "Given the Rover is facing West and is at position(0,0), when the user tries to move forward, the rovers position does not change" do
      current_position = RoverServer.move_to({:north, [0, 0]})
      assert [0, 0] = current_position
    end
  end
end
