defmodule Pot.File do
  use GenServer

  def start_link(path) do
    GenServer.start_link(__MODULE__, path)
  end

  def init(path) do
    Registry.register(Pot.File.Registry, path, nil)
    {:ok, path}
  end

  def write(path, temp_file) do
    Pot.File.Util.write(path, temp_file)
  end

  def which_node?(path) do
    Pot.File.Util.which_node?(path)
  end

  def delete(path) do
    Pot.File.Util.delete(path)
  end
end
