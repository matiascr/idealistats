defmodule Auth do
  @moduledoc """
  Provides an interface with Idealista.com
  """

  @doc """
  Returns the authentication header.

  ## Parameters

    - `auth`: Map containing:
      - `id`: String with the authentication name.
      - `secret`: String with the authentication secret.
  """
  @spec get_header(%{id: String.t(), secret: String.t()}) :: String.t()
  def get_header(auth) do
    encodedBytes = Fast64.encode64(auth.id <> ":" <> auth.secret)
    "Basic " <> encodedBytes
  end

  @doc """
  Returns the authentication token.

  ## Parameters

    - `auth_header`: String with the authentication header.
  """
  @spec get_token(String.t()) :: String.t()
  def get_token(auth_header) do
    {:ok, %{body: body}} =
      Tesla.post(
        "https://api.idealista.com/oauth/token",
        "",
        query: [
          grant_type: "client_credentials",
          scope: "read"
        ],
        headers: [
          {"Authorization", auth_header},
          {"Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"}
        ]
      )

    body
    |> Jason.decode!()
    |> Map.fetch!("access_token")
  end
end
