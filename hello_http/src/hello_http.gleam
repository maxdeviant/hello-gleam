import gleam/erlang/process
import gleam/http/cowboy
import gleam/http
import gleam/http/response.{Response}
import gleam/http/request.{Request}
import gleam/io
import gleam/bit_builder.{BitBuilder}
import gleam/option.{None, Option, Some}
import gleam/json

type User {
  User(id: String, full_name: String, age: Option(Int))
}

fn user_to_json(user: User) -> String {
  json.object([
    #("id", json.string(user.id)),
    #("full_name", json.string(user.full_name)),
    #("age", json.nullable(user.age, of: json.int)),
  ])
  |> json.to_string
}

pub fn my_service(request: Request(t)) -> Response(BitBuilder) {
  let path_segments =
    request
    |> request.path_segments

  io.debug(path_segments)

  case #(request.method, path_segments) {
    #(http.Get, []) -> {
      let user = User(id: "1", full_name: "Jeremiah", age: Some(27))

      let body =
        bit_builder.from_string(
          user
          |> user_to_json,
        )

      io.debug(user)

      response.new(200)
      |> response.prepend_header("made-with", "Gleam")
      |> response.prepend_header("content-type", "application/json")
      |> response.set_body(body)
    }
    #(http.Get, ["users", id_or_username]) -> {
      let user = User(id: id_or_username, full_name: id_or_username, age: None)

      let body =
        bit_builder.from_string(
          user
          |> user_to_json,
        )

      io.debug(user)

      response.new(200)
      |> response.prepend_header("made-with", "Gleam")
      |> response.prepend_header("content-type", "application/json")
      |> response.set_body(body)
    }
    _ -> {
      response.new(404)
      |> response.set_body(bit_builder.from_string("Not Found"))
    }
  }
}

pub fn main() {
  cowboy.start(my_service, on_port: 3000)
  process.sleep_forever()
}
