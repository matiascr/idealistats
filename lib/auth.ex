defmodule Auth do
  @moduledoc """
  Provides an interface with Idealista.com
  """

  @token_url "https://api.idealista.com/oauth/token"

  @doc """
  Returns the authentication header.

  ## Parameters

    - `auth`: Map containing:
      - `id`: String with the authentication name.
      - `secret`: String with the authentication secret.
  """
  @spec get_header() :: String.t()
  def get_header() do
    File.read!("#{__DIR__}/../auth.json")
    |> Jason.decode!(keys: :atoms)
    |> get_header()
  end

  @spec get_header(%{id: String.t(), secret: String.t()}) :: String.t()
  def get_header(auth) do
    encodedBytes = Base.encode64(auth.id <> ":" <> auth.secret)
    "Basic #{encodedBytes}"
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
        @token_url,
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
