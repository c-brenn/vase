defmodule Urn.Authentication.Token do
  @max_age 1209600

  def authenticate(token) do
    status = Phoenix.Token.verify(
      Urn.Endpoint,
      "user",
      token,
      max_age: @max_age
    )

    case status do
      {:ok, username} -> {:ok, username, token}
      {:error, _} -> {:error, :forbidden}
    end
  end
end
