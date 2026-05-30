#!/usr/bin/env bash
set -euo pipefail

snippet_file="snippets/mojo.json"

python -m json.tool "$snippet_file" >/dev/null

grep -q '^snippets = \["\./snippets/mojo\.json"\]$' extension.toml

! grep -q '"fn' "$snippet_file"
! grep -q 'fn ' "$snippet_file"
! grep -q '"prefix": \[' "$snippet_file"

grep -q '"Main function"' "$snippet_file"
grep -q '"Def main function"' "$snippet_file"
grep -q '"Raising function"' "$snippet_file"
grep -q '"Fieldwise init struct"' "$snippet_file"
grep -q '"Init method"' "$snippet_file"
grep -q '"Move init method"' "$snippet_file"
grep -q '"Static method"' "$snippet_file"
grep -q '"Raise error"' "$snippet_file"
grep -q '"List value"' "$snippet_file"
grep -q '"Dict value"' "$snippet_file"
