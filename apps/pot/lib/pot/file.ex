defmodule Pot.File do
  use GenServer

  def start_link(path) do
    GenServer.start_link(__MODULE__, path)
  end

  def init(path) do
    Registry.register(Pot.File.Registry, path, nil)
    {:ok, path}
  end

  def write(path) do
    {:ok, pid} = Pot.File.Supervisor.track_file(path)

    dir = Path.dirname(path)
    base = Path.basename(path)
    register_presences(pid, dir, base)
  end

  def delete(path) do
    Registry.dispatch(Pot.File.Registry, path, fn files ->
      for { pid, _ } <- files do
        GenServer.cast(pid, :delete)
      end
    end)
  end

  def handle_cast(:delete, path) do
    {:stop, :delete, path}
  end

  def terminate(_, _), do: :ok

  defp register_presences(pid, "/", base) do
    Pot.Presence.track(pid, "/", base, %{})
  end
  defp register_presences(pid, dir, base) do
    Pot.Presence.track(pid, dir, base, %{})

    new_dir = Path.dirname(dir)
    new_base = Path.basename(dir)
    register_presences(pid, new_dir, new_base)
  end
end
