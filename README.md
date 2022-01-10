# MixGleam

An Elixir archive that teaches `Mix` how to work with Gleam code and
dependencies!

## Installation

Install the Gleam compiler onto your machine. [Installation instructions can
be found here here](https://gleam.run/getting-started/installing-gleam.html).

Install or update the `MixGleam` archive from Hex:

```shell
$ mix archive.install hex mix_gleam
```

To install or update from source:

```shell
$ mix archive.uninstall mix_gleam # if this archive was previously installed
$ git clone https://github.com/gleam-lang/mix_gleam.git
$ cd mix_gleam
$ MIX_ENV=prod mix do archive.build, archive.install
```

Configure your `Mix` project to use the `MixGleam` archive to work with Gleam's
compiler and Gleam dependencies:

```elixir
# in mix.exs
# ...
  @app :my_gleam_app

  def project do
    [
      app: @app,
      # ...
      archives: [mix_gleam: "~> 0.4.0"],
      aliases: MixGleam.add_aliases(),
      erlc_paths: ["build/dev/erlang/#{@app}/build"],
      erlc_include_path: "build/dev/erlang/#{@app}/include",
      # ...
    ]
  end
# ...
```

To see an entire example `mix.exs` file you can adapt to your existing `Mix`
project:

```shell
$ mix gleam.new --retro
```

If you want to write Gleam code in your project, it's a good idea to add
`gleam_stdlib` and `gleeunit` to your project's dependencies:

```elixir
# in mix.exs
# ...
  defp deps do
    [
      # ...
      {:gleam_stdlib, "~> 0.18"},
      {:gleeunit, "~> 0.5", only: [:dev, :test], runtime: false},
      # ...
    ]
  end
# ...
```

Make a `src` directory for your Gleam code to live in:

```shell
$ mkdir src
```

And add the `build` directory to your `.gitignore` file so Gleam's build
artefacts are not included in your project.
