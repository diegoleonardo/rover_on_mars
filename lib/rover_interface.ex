defmodule RoverOnMars.RoverInterface do
  alias RoverOnMars.RoverServer
  @name :rover_interface

  def start(direction, position) do
    IO.puts("Starting Rover Interface...")
    RoverServer.start_link(direction, position)
    Process.register(self(), @name)
  end

  def set_control() do
    IO.puts(
      "Set command to Rover: L = Rotate to left, R = Rotate to right, M = move forward, Q = Exit"
    )

    input =
      IO.gets("")
      |> String.replace("\n", "")
      |> String.downcase()
      |> String.to_atom()

    set_command(input)
    get_response()
  end

  defp set_command(:m) do
    RoverServer.move()
  end

  defp set_command(:l) do
    RoverServer.rotate_to(:left)
  end

  defp set_command(:r) do
    RoverServer.rotate_to(:right)
  end

  defp set_command(:q) do
    IO.puts("Finishing...")

    pid = Process.whereis(@name)

    pid
    |> Process.exit(:kill)
  end

  defp get_response() do
    response = RoverServer.get_state()

    IO.puts("Current State: #{inspect(response)}")

    set_control()
  end
end
