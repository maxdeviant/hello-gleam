import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Option}

pub opaque type UserId {
  UserId(String)
}

pub type User {
  User(id: UserId, username: String, full_name: Option(String))
}

pub opaque type TodoId {
  TodoId(String)
}

pub type Todo {
  Todo(id: TodoId, user_id: UserId, text: String)
}

pub fn main() {
  let user = User(id: UserId("1"), username: "example_user", full_name: None)

  let todos = [
    Todo(id: TodoId("todo_1"), user_id: user.id, text: "Learn Gleam."),
    Todo(
      id: TodoId("todo_2"),
      user_id: user.id,
      text: "Build something cool in Gleam.",
    ),
    Todo(id: TodoId("todo_3"), user_id: user.id, text: "???"),
    Todo(id: TodoId("todo_4"), user_id: user.id, text: "Profit."),
  ]

  io.println("Hey there " <> user.username <> "!\n")

  io.println(
    "Looks like you have " <> {
      todos
      |> list.length
      |> int.to_string
    } <> " outstanding todos:",
  )

  todos
  |> list.each(fn(a_todo) { io.println("  - " <> a_todo.text) })
}
