# MixGleam

[![Hex Package](https://img.shields.io/hexpm/v/mix_gleam?color=ffaff3&label&labelColor=2f2f2f&logo=data:image/svg+xml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBmaWxsPSIjZmVmZWZjIiBkPSJNIDYuMjgzMiwxLjU5OTYgOS4yODMyLDYuNzk0OSBIIDE0LjcwNTEgTCAxNy43MDUxLDEuNTk5NiBaIE0gMTguMTQwNywxLjg0MzggbCAtMyw1LjE5NzMgMi43MTQ5LDQuNjk5MiBoIDYgeiBNIDUuODUzNSwxLjg1NTUgMC4xNDQ1LDExLjc0MDIgSCA2LjE0NDUgTCA4Ljg1MTYsNy4wNDg4IFogTSAwLjE0NDUsMTIuMjQwMiA1Ljg1MzUsMjIuMTI3IDguODUxNiwxNi45MzM2IDYuMTQ0NSwxMi4yNDAyIFogbSAxNy43MTEsMCAtMi43MTQ5LDQuNzAxMiAzLDUuMTk1MyA1LjcxNDksLTkuODk2NSB6IE0gOS4yODMyLDE3LjE4NzUgNi4yODUyLDIyLjM4MDkgSCAxNy43MDMyIEwgMTQuNzA1MSwxNy4xODc1IFoiLz48L3N2Zz4K)](https://hex.pm/packages/mix_gleam)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3?label&labelColor=2f2f2f&logo=data:image/svg+xml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNiAyOCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBmaWxsPSIjZmVmZWZjIiBkPSJNMjUuNjA5IDcuNDY5YzAuMzkxIDAuNTYyIDAuNSAxLjI5NyAwLjI4MSAyLjAxNmwtNC4yOTcgMTQuMTU2Yy0wLjM5MSAxLjMyOC0xLjc2NiAyLjM1OS0zLjEwOSAyLjM1OWgtMTQuNDIyYy0xLjU5NCAwLTMuMjk3LTEuMjY2LTMuODc1LTIuODkxLTAuMjUtMC43MDMtMC4yNS0xLjM5MS0wLjAzMS0xLjk4NCAwLjAzMS0wLjMxMyAwLjA5NC0wLjYyNSAwLjEwOS0xIDAuMDE2LTAuMjUtMC4xMjUtMC40NTMtMC4wOTQtMC42NDEgMC4wNjMtMC4zNzUgMC4zOTEtMC42NDEgMC42NDEtMS4wNjIgMC40NjktMC43ODEgMS0yLjA0NyAxLjE3Mi0yLjg1OSAwLjA3OC0wLjI5Ny0wLjA3OC0wLjY0MSAwLTAuOTA2IDAuMDc4LTAuMjk3IDAuMzc1LTAuNTE2IDAuNTMxLTAuNzk3IDAuNDIyLTAuNzE5IDAuOTY5LTIuMTA5IDEuMDQ3LTIuODQ0IDAuMDMxLTAuMzI4LTAuMTI1LTAuNjg4LTAuMDMxLTAuOTM4IDAuMTA5LTAuMzU5IDAuNDUzLTAuNTE2IDAuNjg4LTAuODI4IDAuMzc1LTAuNTE2IDEtMiAxLjA5NC0yLjgyOCAwLjAzMS0wLjI2Ni0wLjEyNS0wLjUzMS0wLjA3OC0wLjgxMiAwLjA2My0wLjI5NyAwLjQzOC0wLjYwOSAwLjY4OC0wLjk2OSAwLjY1Ni0wLjk2OSAwLjc4MS0zLjEwOSAyLjc2Ni0yLjU0N2wtMC4wMTYgMC4wNDdjMC4yNjYtMC4wNjMgMC41MzEtMC4xNDEgMC43OTctMC4xNDFoMTEuODkxYzAuNzM0IDAgMS4zOTEgMC4zMjggMS43ODEgMC44NzUgMC40MDYgMC41NjIgMC41IDEuMjk3IDAuMjgxIDIuMDMxbC00LjI4MSAxNC4xNTZjLTAuNzM0IDIuNDA2LTEuMTQxIDIuOTM4LTMuMTI1IDIuOTM4aC0xMy41NzhjLTAuMjAzIDAtMC40NTMgMC4wNDctMC41OTQgMC4yMzQtMC4xMjUgMC4xODctMC4xNDEgMC4zMjgtMC4wMTYgMC42NzIgMC4zMTMgMC45MDYgMS4zOTEgMS4wOTQgMi4yNSAxLjA5NGgxNC40MjJjMC41NzggMCAxLjI1LTAuMzI4IDEuNDIyLTAuODkxbDQuNjg4LTE1LjQyMmMwLjA5NC0wLjI5NyAwLjA5NC0wLjYwOSAwLjA3OC0wLjg5MSAwLjM1OSAwLjE0MSAwLjY4OCAwLjM1OSAwLjkyMiAwLjY3MnpNOC45ODQgNy41Yy0wLjA5NCAwLjI4MSAwLjA2MyAwLjUgMC4zNDQgMC41aDkuNWMwLjI2NiAwIDAuNTYyLTAuMjE5IDAuNjU2LTAuNWwwLjMyOC0xYzAuMDk0LTAuMjgxLTAuMDYzLTAuNS0wLjM0NC0wLjVoLTkuNWMtMC4yNjYgMC0wLjU2MiAwLjIxOS0wLjY1NiAwLjV6TTcuNjg4IDExLjVjLTAuMDk0IDAuMjgxIDAuMDYzIDAuNSAwLjM0NCAwLjVoOS41YzAuMjY2IDAgMC41NjItMC4yMTkgMC42NTYtMC41bDAuMzI4LTFjMC4wOTQtMC4yODEtMC4wNjMtMC41LTAuMzQ0LTAuNWgtOS41Yy0wLjI2NiAwLTAuNTYyIDAuMjE5LTAuNjU2IDAuNXoiPjwvcGF0aD48L3N2Zz4K)](https://hexdocs.pm/mix_gleam/)
[![Licence](https://img.shields.io/hexpm/l/mix_gleam?color=ffaff3&label&labelColor=2f2f2f&logo=data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjM0IiBoZWlnaHQ9IjI4IiB2aWV3Qm94PSIwIDAgMzQgMjgiPgo8cGF0aCBmaWxsPSIjZmVmZWZjIiBkPSJNMjcgN2wtNiAxMWgxMnpNNyA3bC02IDExaDEyek0xOS44MjggNGMtMC4yOTcgMC44NDQtMC45ODQgMS41MzEtMS44MjggMS44Mjh2MjAuMTcyaDkuNWMwLjI4MSAwIDAuNSAwLjIxOSAwLjUgMC41djFjMCAwLjI4MS0wLjIxOSAwLjUtMC41IDAuNWgtMjFjLTAuMjgxIDAtMC41LTAuMjE5LTAuNS0wLjV2LTFjMC0wLjI4MSAwLjIxOS0wLjUgMC41LTAuNWg5LjV2LTIwLjE3MmMtMC44NDQtMC4yOTctMS41MzEtMC45ODQtMS44MjgtMS44MjhoLTcuNjcyYy0wLjI4MSAwLTAuNS0wLjIxOS0wLjUtMC41di0xYzAtMC4yODEgMC4yMTktMC41IDAuNS0wLjVoNy42NzJjMC40MjItMS4xNzIgMS41MTYtMiAyLjgyOC0yczIuNDA2IDAuODI4IDIuODI4IDJoNy42NzJjMC4yODEgMCAwLjUgMC4yMTkgMC41IDAuNXYxYzAgMC4yODEtMC4yMTkgMC41LTAuNSAwLjVoLTcuNjcyek0xNyA0LjI1YzAuNjg4IDAgMS4yNS0wLjU2MiAxLjI1LTEuMjVzLTAuNTYyLTEuMjUtMS4yNS0xLjI1LTEuMjUgMC41NjItMS4yNSAxLjI1IDAuNTYyIDEuMjUgMS4yNSAxLjI1ek0zNCAxOGMwIDMuMjE5LTQuNDUzIDQuNS03IDQuNXMtNy0xLjI4MS03LTQuNXYwYzAtMC42MDkgNS40NTMtMTAuMjY2IDYuMTI1LTExLjQ4NCAwLjE3Mi0wLjMxMyAwLjUxNi0wLjUxNiAwLjg3NS0wLjUxNnMwLjcwMyAwLjIwMyAwLjg3NSAwLjUxNmMwLjY3MiAxLjIxOSA2LjEyNSAxMC44NzUgNi4xMjUgMTEuNDg0djB6TTE0IDE4YzAgMy4yMTktNC40NTMgNC41LTcgNC41cy03LTEuMjgxLTctNC41djBjMC0wLjYwOSA1LjQ1My0xMC4yNjYgNi4xMjUtMTEuNDg0IDAuMTcyLTAuMzEzIDAuNTE2LTAuNTE2IDAuODc1LTAuNTE2czAuNzAzIDAuMjAzIDAuODc1IDAuNTE2YzAuNjcyIDEuMjE5IDYuMTI1IDEwLjg3NSA2LjEyNSAxMS40ODR6Ij48L3BhdGg+Cjwvc3ZnPgo=)](https://github.com/gleam-lang/mix_gleam/blob/main/LICENCE)
[![Build](https://img.shields.io/github/actions/workflow/status/gleam-lang/mix_gleam/ci.yml?branch=main&color=ffaff3&label&labelColor=2f2f2f&logo=github-actions&logoColor=fefefc)](https://github.com/gleam-lang/mix_gleam/actions)

An Elixir archive that teaches `Mix` how to work with Gleam code and
dependencies!

## Installation

Install the Gleam compiler onto your machine.
[Installation instructions can be found here](https://gleam.run/getting-started/installing-gleam.html).

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
      archives: [mix_gleam: "~> 0.6"],
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
      # For Elixir >= v1.15.0
      prune_code_paths: false,
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
      {:gleam_stdlib, "~> 0.34 or ~> 1.0"},
      {:gleeunit, "~> 1.0", only: [:dev, :test], runtime: false},
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

Check the [test project](test_projects/basic_project/) for an example that
contains both Elixir and Gleam code. See the
[Elixir](test_projects/basic_project/test/basic_project_test.exs) and
[Gleam](test_projects/basic_project/test/basic_project_test.gleam) test files to
find examples on calling Gleam code from Elixir, and vice-versa.
