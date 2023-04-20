# MixGleam

[![Hex Package](https://img.shields.io/hexpm/v/mix_gleam?color=ffaff3&label=%F0%9F%93%A6)](https://hex.pm/packages/mix_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3?label=%F0%9F%93%9A)](https://hexdocs.pm/mix_gleam/)
[![Licence](https://img.shields.io/hexpm/l/mix_gleam?color=ffaff3&label=%F0%9F%93%83)](https://github.com/gleam-lang/mix_gleam/blob/main/LICENCE)
[![Build](https://img.shields.io/github/workflow/status/gleam-lang/mix_gleam/CI?color=ffaff3&label=%E2%9C%A8)](https://github.com/gleam-lang/mix_gleam/actions)

An Elixir archive that teaches `Mix` how to work with Gleam code and
dependencies!

## Installation

Install the Gleam compiler onto your machine. [Installation instructions can
be found here](https://gleam.run/getting-started/installing-gleam.html).

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
      archives: [mix_gleam: "~> 0.6.1"],
      compilers: [:gleam | Mix.compilers()],
      aliases: [
        # Or add this to your aliases function
        "deps.get": ["deps.get", "gleam.deps.get"]
      ],
      erlc_paths: [
        "build/dev/erlang/#{@app}/_gleam_artefacts",
        # For Gleam < v0.25.0
        "build/dev/erlang/#{@app}/build"
      ],
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
      {:gleam_stdlib, "~> 0.28"},
      {:gleeunit, "~> 0.10", only: [:dev, :test], runtime: false},
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

To run Gleam tests from the `test/` directory with `:gleeunit`, you can run:

```shell
$ mix gleam.test
```

## Example

Check the [test project](test_projects/basic_project/) for an example that contains both Elixir and Gleam code. See the
[Elixir](test_projects/basic_project/test/basic_project_test.exs)
and [Gleam](test_projects/basic_project/test/basic_project_test.gleam)
test files to find examples on calling Gleam code from Elixir,
and vice-versa.
