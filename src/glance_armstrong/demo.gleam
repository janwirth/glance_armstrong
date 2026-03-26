import glance
import glance_armstrong
import gleam/io
import gleam/string

/// Prints every public diagnostic style. Run: `gleam run -m demo`
pub fn main() -> Nil {
  section("format_source_diagnostic — underline span (multi-caret)")
  glance_armstrong.format_source_diagnostic(
    "let answer = 42",
    glance.Span(4, 10),
    "unknown name `answer`",
  )
  |> io.println

  section(
    "format_source_diagnostic — \"generic parameters\" highlights (...) on the line",
  )
  glance_armstrong.format_source_diagnostic(
    "fn wrap(x: List(Int)) { x }",
    glance.Span(0, 3),
    "these generic parameters are not allowed here",
  )
  |> io.println

  section(
    "format_source_diagnostic — same line, normal underline (message has no trigger)",
  )
  glance_armstrong.format_source_diagnostic(
    "fn wrap(x: List(Int)) { x }",
    glance.Span(0, 3),
    "expected a different kind of function",
  )
  |> io.println

  section("format_diagnostic_without_span")
  glance_armstrong.format_diagnostic_without_span("module `oops` was not found")
  |> io.println

  section("format_source_diagnostic_with_tips")
  let line = "pub fn example() -> Nil { Nil }"
  let span = glance.Span(0, string.byte_size(line))
  glance_armstrong.format_source_diagnostic_with_tips(
    line,
    span,
    "public functions need an explicit return type in this context",
    [
      "Add a `-> Result` (or similar) after the parameter list.",
      "Example:\n\npub fn ok() -> Nil { Nil }",
    ],
  )
  |> io.println

  section("format_diagnostic_without_span_with_tips")
  glance_armstrong.format_diagnostic_without_span_with_tips(
    "could not read file",
    [
      "Check the path.",
      "Ensure the file is UTF-8.",
    ],
  )
  |> io.println

  section("format_glance_parse_error — unexpected end of input")
  let eof_src = "fn unfinished("
  case glance.module(eof_src) {
    Error(e) -> glance_armstrong.format_glance_parse_error(eof_src, e)
    Ok(_) -> "unexpected: parse succeeded"
  }
  |> io.println

  section(
    "format_glance_parse_error — unexpected token (wrong token where a name was expected)",
  )
  let tok_src = "pub type lower {}"
  case glance.module(tok_src) {
    Error(e) -> glance_armstrong.format_glance_parse_error(tok_src, e)
    Ok(_) -> "unexpected: parse succeeded"
  }
  |> io.println

  section("format_reference_line (related code note)")
  glance_armstrong.format_reference_line(7, "import gleam/io", "imported here")
  |> io.println

  section("format_reference_line — long line (underlines at most 40 bytes)")
  let long = "let x = string.repeat(\"a\", times: 99)"
  glance_armstrong.format_reference_line(
    2,
    long,
    "context (caret width capped)",
  )
  |> io.println

  io.println("")
  Nil
}

fn section(title: String) -> Nil {
  io.println("")
  io.println("── " <> title <> " ──")
  io.println("")
}
