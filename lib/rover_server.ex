defmodule RoverOnMars.RoverServer do
  use GenServer
  alias RoverOnMars.RoverState

  @name :rover_server
  @limit_value_to_north_and_west 0
  @limit_valie_to_south_and_east 3

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
      iex> RoverOnMars.RoverServer.move()
      [0,1]
      
      iex> RoverOnMars.RoverServer.start_link(:north, [0,0])
      iex> RoverOnMars.RoverServer.move()
      [0,0]

  """
  def move() do
    GenServer.call(@name, :move)
  end

  def get_state() do
    GenServer.call(@name, :get_state)
  end

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

  def handle_call(:get_state, _from, state) do
    {:reply, {state.current_facing, state.current_position}, state}
  end

  def handle_call(:move, _from, state) do
    position = move(state.current_facing, state.current_position)

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

  defp switch({:left, position}) do
    case position do
      :north -> :west
      :west -> :south
      :south -> :east
      :east -> :north
    end
  end

  defp switch({:right, position}) do
    case position do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  defp move(:north, [vertical, horizontal]) do
    case vertical do
      @limit_value_to_north_and_west ->
        [vertical, horizontal]

      _ ->
        new_vertical = vertical - 1
        [new_vertical, horizontal]
    end
  end

  defp move(:south, [vertical, horizontal]) do
    case vertical do
      @limit_valie_to_south_and_east ->
        [vertical, horizontal]

      _ ->
        new_vertical = vertical + 1
        [new_vertical, horizontal]
    end
  end

  defp move(:east, [vertical, horizontal]) do
    case horizontal do
      @limit_valie_to_south_and_east ->
        [vertical, horizontal]

      _ ->
        new_horizontal = horizontal + 1
        [vertical, new_horizontal]
    end
  end

  defp move(:west, [vertical, horizontal]) do
    case horizontal do
      @limit_value_to_north_and_west ->
        [vertical, horizontal]

      _ ->
        new_horizontal = horizontal - 1
        [vertical, new_horizontal]
    end
  end
end
