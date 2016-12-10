defmodule Pot.Dir do
  def ls(path) do
    path
    |> Pot.Presence.list
    |> Enum.reduce({[],[]}, fn({name, metas}, {files, dirs}) ->
      %{metas: [%{type: type}|_]} = metas
      case type do
        :file ->
          {[name|files], dirs}
        :directory ->
          {files, [name|dirs]}
      end
    end)
  end
end
