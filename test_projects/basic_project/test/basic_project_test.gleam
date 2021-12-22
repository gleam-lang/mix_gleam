import gleeunit
import basic_project.{Thing, World}

pub fn main() {
  gleeunit.main()
}

pub fn gleam_code_test() {
  assert World = basic_project.hello()
}

pub fn elixir_code_test() {
  assert World = hello_elixir()
}

external fn hello_elixir() -> Thing =
  "Elixir.BasicProject" "hello"
