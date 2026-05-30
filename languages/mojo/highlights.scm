; Mojo self / Self (highlighted before the general naming-convention
; rules below so they take precedence on the literal identifiers).

(identifier) @variable

((identifier) @variable.builtin
 (#eq? @variable.builtin "self"))

((identifier) @type.builtin
 (#eq? @type.builtin "Self"))

; Identifier naming conventions

((identifier) @type.builtin
 (#match? @type.builtin "^(AnyType|Bool|DType|Dict|DynamicVector|Error|FalseType|Float16|Float32|Float64|Index|Int|Int8|Int16|Int32|Int64|List|NoneType|Object|Optional|SIMD|Self|String|Tuple|UInt|UInt8|UInt16|UInt32|UInt64|Variant|VariadicList|VariadicPack)$"))

((identifier) @constructor
 (#match? @constructor "^[A-Z]"))

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z_]*$"))

; Builtin functions

; Audited against Mojo stdlib tag mojo/v1.0.0b1 (std/prelude/__init__.mojo).
; Python-only names (exec, eval, callable, compile, vars, bool, int, float,
; list, dict, set, str, tuple, ...) dropped — Mojo's equivalents are
; capitalized types (Bool, Int, Float64, List, Dict, ...) and already match
; the @constructor rule above. Lowercase Mojo-prelude callables retained;
; idiomatic Mojo builtins (abort, debug_assert, external_call, ...) added.
((call
  function: (identifier) @function.builtin)
 (#match?
   @function.builtin
   "^(abort|abs|all|any|ascii|atof|atol|bin|breakpoint|chr|constrained|debug_assert|divmod|enumerate|external_call|hash|hex|input|iter|len|map|materialize|max|min|next|oct|open|ord|partition|pow|print|range|rebind|rebind_var|reflect|repr|reversed|round|slice|sort|swap|trait_downcast|trait_downcast_var|zip)$"))

; Mojo built-in decorators (recognized before the generic @function below)

((decorator
  (identifier) @attribute.builtin)
 (#match? @attribute.builtin "^(fieldwise_init|register_passable|parameter|value|always_inline|noinline|staticmethod|nonmaterializable)$"))

((decorator
  (call function: (identifier) @attribute.builtin))
 (#match? @attribute.builtin "^(fieldwise_init|register_passable|parameter|value|always_inline|noinline|staticmethod|nonmaterializable)$"))

; Function calls

(decorator) @function

(call
  function: (attribute attribute: (identifier) @function.method))
(call
  function: (identifier) @function)

; Function definitions

(function_definition
  name: (identifier) @function)

(attribute attribute: (identifier) @property)
(type (identifier) @type)

; Literals

[
  (none)
  (true)
  (false)
] @constant.builtin

[
  (integer)
  (float)
] @number

(comment) @comment
(string) @string
(escape_sequence) @escape

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special) @embedded

[
  "-"
  "-="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "%"
  "%="
  "^"
  "+"
  "->"
  "+="
  "<"
  "<<"
  "<="
  "<>"
  "="
  ":="
  "=="
  ">"
  ">="
  ">>"
  "|"
  "~"
  "and"
  "in"
  "is"
  "not"
  "or"
] @operator

[
  "as"
  "assert"
  "async"
  "await"
  "break"
  "class"
  "continue"
  "def"
  "del"
  "elif"
  "else"
  "except"
  "exec"
  "finally"
  "for"
  "from"
  "global"
  "if"
  "import"
  "lambda"
  "nonlocal"
  "pass"
  "print"
  "raise"
  "return"
  "try"
  "while"
  "with"
  "yield"
] @keyword

; Mojo-specific declaration keywords. The grammar accepts each as an
; anonymous string token (see grammar.js: `fn` in function_definition,
; `raises` in raises_clause, etc.), so literal-token highlighting fires.

[
  "fn"
  "var"
  "struct"
  "trait"
  "alias"
  "comptime"
] @keyword

; `raises` is wrapped in a single-token rule (raises_clause) by the
; grammar, so highlight it via the rule rather than the bare literal.

(raises_clause) @keyword

; Mojo argument-convention keywords. Appear only inside `mojo_parameter`
; (see grammar.js: argument_convention). Captured as @keyword.modifier so
; themes can color them distinctly from control-flow keywords.

[
  "owned"
  "borrowed"
  "inout"
  "mut"
  "read"
  "ref"
  "out"
  "deinit"
] @keyword.modifier
