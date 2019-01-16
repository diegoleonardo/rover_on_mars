defmodule RoverOnMars.RoverServer do
  use GenServer
  alias RoverOnMars.RoverState

  @name :rover_server
  @min_value_to_north_and_west 0
  @max_value_to_south_and_east 3
  def start_link(init_direction, init_position) do
    GenServer.start_link(
      __MODULE__,
      %RoverState{current_facing: init_direction, current_position: init_position},
      name: @name
    )
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:north, _from, state) do
    [vertical, horizontal] = state.current_position

    position =
      case vertical do
        @min_value_to_north_and_west ->
          state.current_position

        _ ->
          new_vertical = vertical - 1
          [new_vertical, horizontal]
      end

    new_state = %{state | current_position: position}
    {:reply, position, new_state}
  end

  def handle_call(:south, _from, state) do
    [vertical, horizontal] = state.current_position

    position =
      case vertical do
        @max_value_to_south_and_east ->
          state.current_position

        _ ->
          new_vertical = vertical + 1
          [new_vertical, horizontal]
      end

    new_state = %{state | current_position: position}
    {:reply, position, new_state}
  end

  def handle_call(:east, _from, state) do
    [vertical, horizontal] = state.current_position

    position =
      case horizontal do
        @max_value_to_south_and_east ->
          state.current_position

        _ ->
          new_horizontal = horizontal + 1
          [vertical, new_horizontal]
      end

    new_state = %{state | current_position: position}
    {:reply, position, new_state}
  end

  def handle_call(:west, _from, state) do
    [vertical, horizontal] = state.current_position

    position =
      case horizontal do
        @min_value_to_north_and_west ->
          state.current_position

        _ ->
          new_horizontal = horizontal - 1
          [vertical, new_horizontal]
      end

    new_state = %{state | current_position: position}
    {:reply, position, new_state}
  end

  def handle_call(direction, _from, state) do
    new_direction_facing = switch({direction, state.current_facing})
    new_state = %{state | current_facing: new_direction_facing}
    {:reply, new_direction_facing, new_state}
  end

  def handle_info(:work, state) do
    {:noreply, state}
  end

  @doc """
  Function used to rotate the rover 

  Possible rotations: :left, :right

  Possible directions to facing: :north, :south, :east, :west

  ## Examples

      iex> RoverOnMars.RoverServer.start_link(:north, [1,1])
      iex> RoverOnMars.RoverServer.rotate_to(:left)
      :west

      iex> RoverOnMars.RoverServer.start_link(:north, [1,1])
      iex> RoverOnMars.RoverServer.rotate_to(:right)
      :east

  """
  def rotate_to(direction) do
    GenServer.call(@name, direction)
  end

  @doc """
  Function used to move forward the rover 

  ## Examples

      iex> RoverOnMars.RoverServer.start_link(:north, [1,1])
      iex> RoverOnMars.RoverServer.move_to(:north)
      [0,1]
      
      iex> RoverOnMars.RoverServer.start_link(:north, [0,0])
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
