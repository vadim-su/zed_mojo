#!/usr/bin/env bash
set -euo pipefail

query_file="languages/mojo/highlights.scm"

line_for_exact() {
  local pattern="$1"
  local line
  line="$(grep -nFx "$pattern" "$query_file" | head -n1 | cut -d: -f1)"
  test -n "$line"
  printf '%s\n' "$line"
}

line_for_contains() {
  local pattern="$1"
  local line
  line="$(grep -nF "$pattern" "$query_file" | head -n1 | cut -d: -f1)"
  test -n "$line"
  printf '%s\n' "$line"
}

variable_line="$(line_for_exact "(identifier) @variable")"
function_call_line="$(line_for_contains "function: (identifier) @function)")"
function_definition_line="$(line_for_contains "name: (identifier) @function)")"
builtin_type_line="$(line_for_contains "@type.builtin")"
type_line="$(line_for_exact "(type (identifier) @type)")"

grep -q "DType|Dict|DynamicVector" "$query_file"

test "$variable_line" -lt "$function_call_line"
test "$variable_line" -lt "$function_definition_line"
test "$builtin_type_line" -lt "$type_line"
