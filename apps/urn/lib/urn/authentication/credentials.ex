defmodule Urn.Authentication.Credentials do
  @secret "secret"

  def authenticate(username, password) do
    case password do
      @secret ->
        {:ok, username}
      _ ->
        {:error, :forbidden}
    end
  end
end
