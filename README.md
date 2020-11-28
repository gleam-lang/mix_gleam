# MixGleam

A mix plugin for compiling Gleam code!

## Installation

Install the Gleam compiler onto your machine. [Installation instructions can
be found here here](https://gleam.run/getting-started/installing-gleam.html).

Add `mix_gleam` to your mix project deps:

```elixir
# in mix.exs
def deps do
  [
    {:mix_gleam, "~> 0.1.0"},
  ]
end
```

Configure your mix project to add the Gleam compiler and to compile Erlang
that Gleam generates:

```elixir
# in mix.exs
def project do
  [
    # ...
    erlc_paths: ["src", "gen"],
    compilers: [:gleam | Mix.compilers()], # Gleam must go first
  ]
end
```

Create a `gleam.toml` file containing the name of your OTP application:

```toml
# In a new gleam.toml file
name = "my_cool_project"
version = "0.0.1"
```

Make a `src` directory for your Gleam code to live in:

```
mkdir src
```

And add `gen` to your `.gitignore` so that the generated Erlang is not
included in your project.
