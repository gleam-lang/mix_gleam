import gleeunit
import basic_project.{type Thing, World}

pub fn main() {
  gleeunit.main()
}

pub fn gleam_code_test() {
  let assert World = basic_project.hello()
}

pub fn elixir_code_test() {
  let assert World = hello_elixir()
}

@external(erlang, "Elixir.BasicProject", "hello")
fn hello_elixir() -> Thing
