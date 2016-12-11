defmodule Pot.Dir do
  def ls(path) do
    path
    |> Pot.Presence.list
  end
end
