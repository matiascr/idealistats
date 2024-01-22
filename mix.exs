defmodule Idealistats.MixProject do
  use Mix.Project

  def project do
    [
      app: :idealistats,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:fast64, "~> 0.1.3"},
      {:jason, "~> 1.4.1"},
      {:nimble_options, "~> 1.0"},
      {:tesla, "~> 1.8.0"}
    ]
  end
end
