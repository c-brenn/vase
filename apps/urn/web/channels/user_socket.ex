defmodule Urn.UserSocket do
  use Phoenix.Socket
  alias Urn.Authentication.Token

  ## Channels
  channel "directories:*", Urn.DirectoriesChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Token.authenticate(token) do
      {:ok, _username, _token} -> {:ok, socket}
      {:error, :forbidden} -> :error
    end
  end

  def id(_socket), do: nil
end
