#!/usr/bin/env bash
set -euo pipefail

runnables_file="languages/mojo/runnables.scm"
tasks_file="languages/mojo/tasks.json"

test -f "$runnables_file"
test -f "$tasks_file"

grep -q '@run' "$runnables_file"
grep -q 'mojo-main' "$runnables_file"
grep -q 'function_definition' "$runnables_file"
grep -q '"tags": \["mojo-main"\]' "$tasks_file"
grep -q '"command": "mojo"' "$tasks_file"
grep -q '"args": \["run", "\$ZED_FILE"\]' "$tasks_file"
