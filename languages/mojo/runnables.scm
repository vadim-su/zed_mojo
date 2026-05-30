; Show a runnable indicator on Mojo entry points (`def main` or `fn main`).
; Bind this tag from a Zed task with `tags = ["mojo-main"]`.

(function_definition
  name: (identifier) @run
  (#eq? @run "main")
  (#set! tag mojo-main))
