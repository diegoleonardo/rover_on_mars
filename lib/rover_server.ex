defmodule RoverOnMars.RoverServer do
  def rotate_to({direction, position}) do
    switch({direction, position})
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
