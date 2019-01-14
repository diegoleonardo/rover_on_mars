defmodule RoverOnMars.RoverServer do
  use GenServer

  @name :rover_server
  @min_value_to_north_and_west 0
  @max_value_to_south_and_east 3
  def start_link(init_state) do
    GenServer.start_link(__MODULE__, init_state, name: @name)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:north, _from, [vertical, horizontal] = state) do
    new_state =
      case vertical do
        @min_value_to_north_and_west ->
          state

        _ ->
          new_vertical = vertical - 1
          [new_vertical, horizontal]
      end

    {:reply, new_state, new_state}
  end

  def handle_call(:south, _from, [vertical, horizontal] = state) do
    new_state =
      case vertical do
        @max_value_to_south_and_east ->
          state

        _ ->
          new_vertical = vertical + 1
          [new_vertical, horizontal]
      end

    {:reply, new_state, new_state}
  end

  def handle_call(:east, _from, [vertical, horizontal] = state) do
    new_state =
      case horizontal do
        @max_value_to_south_and_east ->
          state

        _ ->
          new_horizontal = horizontal + 1
          [vertical, new_horizontal]
      end

    {:reply, new_state, new_state}
  end

  def handle_call(:west, _from, [vertical, horizontal] = state) do
    new_state =
      case horizontal do
        @min_value_to_north_and_west ->
          state

        _ ->
          new_horizontal = horizontal - 1
          [vertical, new_horizontal]
      end

    {:reply, new_state, new_state}
  end

  def handl_call(_, _from, state) do
    IO.puts("entou em hand_call padrao")
    {:reply, state, state}
  end

  def handle_info(:work, state) do
    {:noreply, state}
  end

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

      iex> RoverOnMars.RoverServer.start_link([1,1])
      iex> RoverOnMars.RoverServer.move_to(:north)
      [0,1]
      
      iex> RoverOnMars.RoverServer.start_link([0,0])
      iex> RoverOnMars.RoverServer.move_to(:north)
      [0,0]

  """
  def move_to(direction) do
    GenServer.call(@name, direction)
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
