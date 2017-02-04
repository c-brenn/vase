defmodule Urn.Authentication.Credentials do
  @remote_config Application.get_env(:urn, :auth_service)
  @remote_url "#{@remote_config[:host]}:#{@remote_config[:port]}"

  def authenticate(username, password) do
    case remote_authenticate(username, password) do
      :ok ->
        {:ok, username}
      :error ->
        {:error, :forbidden}
    end
  end

  defp remote_authenticate(username, password) do
    body = {:form, [username: username, password: password]}
    case HTTPoison.post(@remote_url, body) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        :ok
      _ ->
        :error
    end
  end
end
