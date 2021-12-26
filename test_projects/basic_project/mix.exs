defmodule BasicProject.MixProject do
  use Mix.Project

  @app :basic_project
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # New items added for Gleam compilation
      # compilers: [:gleam | Mix.compilers()],
      archives: [mix_gleam: "~> 0.3.0"],
      aliases: MixGleam.add_aliases(),
      erlc_paths: ["build/dev/erlang/#{@app}/build"],
      erlc_include_path: "build/dev/erlang/#{@app}/include"
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
      # {:mix_gleam, path: "../../"}
      {:gleam_stdlib, "~> 0.18"},
      {:gleeunit, "~> 0.5", only: [:dev, :test]}
    ]
  end
end
