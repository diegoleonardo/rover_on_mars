defmodule RoverOnMars.RoverServer do
  @doc """
  Function used to rotate the rover 

  Possible rotations: :left, :right

  Possible directions to facing: :north, :south, :east, :west

  ## Examples

      iex> RoverOnMars.RoverServer.rotate_to({:left, :north})
      :west

      iex> RoverOnMars.RoverServer.rotate_to({:right, :north})
      :east

  """
  def rotate_to({direction, position}) do
    switch({direction, position})
  end

  @doc """
  Function used to move forward the rover 

  ## Examples

      iex> RoverOnMars.RoverServer.move_to({:north, [1,1]})
      [0,1]

      iex> RoverOnMars.RoverServer.move_to({:north, [0,0]})
      [0,0]

  """
  def move_to({direction, [vertical, horizontal] = current_position}) do
    case direction do
      :north when vertical > 0 ->
        new_vertical = vertical - 1
        [new_vertical, horizontal]

      :south when vertical < 3 ->
        new_vertical = vertical + 1
        [new_vertical, horizontal]

      :east when horizontal < 3 ->
        new_horizontal = horizontal + 1
        [vertical, new_horizontal]

      :west when horizontal > 0 ->
        new_horizontal = horizontal - 1
        [vertical, new_horizontal]

      __ ->
        current_position
    end
  end

  defp switch({direction, position}) when direction == :left do
    case position do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
  end

  defp switch({direction, position}) when direction == :right do
    case position do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end
end
