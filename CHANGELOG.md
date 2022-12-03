# Changelog

## Unreleased

- Fixed a bug where compiling on Windows would fail for projects with a `priv`
  directory.

## v0.6.0 - 2022-06-16

- `mix gleam.compile` task is renamed to `mix compile.gleam` for compatibility
  with the `:compilers` Mix.Project option.
- `MixGleam.add_aliases` is deprecated in favor of adding `:gleam` to `:compilers`
  and specifying an alias for `:"deps.get"`.

## v0.5.0 - 2022-06-08

- Gleam code is now compiled from Mix's `_build` directory. The presence of
  `gleam.toml` in a project's base directory is no longer required.

## v0.4.0 - 2022-01-10

- Updated to work with the `gleam compile-package` v0.19 API.

## v0.3.0 - 2021-12-26

- Updated to work with the `gleam compile-package` API for incremental builds
  and support for packages published with the Gleam build tool.
