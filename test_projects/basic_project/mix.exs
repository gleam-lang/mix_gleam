defmodule BasicProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :basic_project,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # New items added for Gleam compilation
      compilers: [:gleam | Mix.compilers()],
      erlc_paths: ["src", "gen"]
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
      {:mix_gleam, path: "../../"}
    ]
  end
end
