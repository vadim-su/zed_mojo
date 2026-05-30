#!/usr/bin/env bash
set -euo pipefail

indent_file="languages/mojo/indents.scm"

test -f "$indent_file"

grep -q '@start.def' "$indent_file"
grep -q '@start.struct' "$indent_file"
grep -q '@start.trait' "$indent_file"
grep -q '@start.if' "$indent_file"
grep -q '@end) @indent' "$indent_file"
grep -q '(function_definition' "$indent_file"
grep -q '(struct_definition' "$indent_file"
grep -q '(trait_definition' "$indent_file"
grep -q '(if_statement' "$indent_file"

! grep -q '":" @indent' "$indent_file"
! grep -q '(block) @indent' "$indent_file"
! grep -q '(block) @end' "$indent_file"
