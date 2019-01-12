defmodule RoverOnMars.RoverServer do
  @doc """
  Function used to rotate the rover 

  ## Examples

      iex> RoverOnMars.RoverServer.rotate_to({:left, :north})
      :west

  """
  def rotate_to({direction, position}) do
    switch({direction, position})
  end

  @doc """
  Function used to move forward the rover 

  ## Examples

      iex> RoverOnMars.RoverServer.move_to({:north, [1,1]})
      [0,1]

  """
  def move_to({direction, current_position}) do
    case direction do
      :north ->
        [vertical, horizontal] = current_position
        new_vertical = vertical - 1
        [new_vertical, horizontal]

      :south ->
        [vertical, horizontal] = current_position
        new_vertical = vertical + 1
        [new_vertical, horizontal]

      :east ->
        [vertical, horizontal] = current_position
        new_horizontal = horizontal + 1
        [vertical, new_horizontal]

      :west ->
        [vertical, horizontal] = current_position
        new_horizontal = horizontal - 1
        [vertical, new_horizontal]
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
