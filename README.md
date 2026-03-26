# glance_armstrong

Terminal diagnostics for Gleam source + [`glance`](https://hex.pm/packages/glance) spans and parse errors.

[![Package Version](https://img.shields.io/hexpm/v/glance_armstrong)](https://hex.pm/packages/glance_armstrong)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glance_armstrong/)

```sh
gleam add glance_armstrong@1
```

```
import glance
import glance_armstrong

── format_source_diagnostic — underline span (multi-caret) ──
glance_armstrong.format_source_diagnostic(
  "let answer = 42",
  glance.Span(4, 10),
  "unknown name `answer`",
)

   1 | let answer = 42
           ^^^^^^ unknown name `answer`

── format_source_diagnostic_with_tips ──
glance_armstrong.format_source_diagnostic_with_tips(
  "pub fn example() -> Nil { Nil }",
  glance.Span(0, 31),
  "public functions need an explicit return type in this context",
  [
    "Add a `-> Result` (or similar) after the parameter list.",
    "Example:\n\npub fn ok() -> Nil { Nil }",
  ],
)

   1 | pub fn example() -> Nil { Nil }
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ public functions need an explicit return type in this context

  • Add a `-> Result` (or similar) after the parameter list.
  • Example:

    pub fn ok() -> Nil { Nil }

── format_reference_line (related code note) ──
glance_armstrong.format_reference_line(7, "import gleam/io", "imported here")

   7 | import gleam/io
       ^^^^^^^^^^^^^^^ imported here

── format_reference_line — long line (underlines at most 40 bytes) ──
glance_armstrong.format_reference_line(
  2,
  "let x = string.repeat(\"a\", times: 99)",
  "context (caret width capped)",
)

   2 | let x = string.repeat("a", times: 99)
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ context (caret width capped)
```

API: <https://hexdocs.pm/glance_armstrong>. Full sampler: `glance_armstrong/demo.gleam`.
