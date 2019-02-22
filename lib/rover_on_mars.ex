defmodule RoverOnMars do
  use Application
  alias RoverOnMars.RoverInterface

  def start(_type, _args) do
    RoverInterface.start(:north, [0, 0])
    {:ok, self()}
  end
end
