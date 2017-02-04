defmodule Pot.File.Supervisor do
  use Supervisor
  @name __MODULE__

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def track_file(path, id) do
    Supervisor.start_child(@name, [path, id])
  end

  def init(:ok) do
    children = [
      worker(Pot.File, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
