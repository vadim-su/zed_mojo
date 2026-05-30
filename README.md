# Mojo language support for Zed

Zed extension that adds Mojo language support for files with the `.mojo` suffix.

## What is included

- Zed extension metadata in `extension.toml`
- Mojo language config in `languages/mojo/config.toml`
- Syntax highlighting queries in `languages/mojo/highlights.scm`
- Editor queries for bracket matching, indentation, outline, and Vim text objects
- LSP integration for `mojo-lsp-server`
- Mojo snippets in `snippets/mojo.json`
- Runnable detection for `def main` / `fn main` in `languages/mojo/runnables.scm`
- Default runnable task binding in `languages/mojo/tasks.json`
- Tree-sitter grammar pinned to [`vadim-su/tree-sitter-mojo`](https://github.com/vadim-su/tree-sitter-mojo)

## Install locally in Zed

1. Open Zed.
2. Run `zed: extensions` from the command palette.
3. Click `Install Dev Extension`.
4. Select this repository directory: `zed_mojo`.
5. Open a `.mojo` file.

If the extension does not appear immediately, reload Zed with `zed: reload window`.

## Mojo language server

This extension registers `mojo-lsp-server` as the default language server for Mojo files. Completion, diagnostics, go-to-definition, hover, and other semantic features come from that LSP server.

The server is launched through the `PATH` inherited by Zed; the extension does not pin a machine-specific executable path.

By default, the extension starts the server with `--skip-docstring-checks`. This avoids extra parsing and type-checking work inside docstring examples, which can otherwise leave the server busy or stale after edits in some Mojo LSP builds.

Before opening a `.mojo` file, make sure the executable is visible from the environment that launches Zed:

```sh
which mojo-lsp-server
```

On Nix systems, launch Zed from a shell where `mojo-lsp-server` resolves successfully, or otherwise expose it through the environment used by Zed.

### Configuring the language server

You can override the language server command, arguments, and environment in Zed settings. This is useful when Mojo imports require extra search paths via `-I`:

```json
{
  "lsp": {
    "mojo-lsp-server": {
      "binary": {
        "path": "mojo-lsp-server",
        "arguments": ["-I", "/path/to/mojo/packages"],
        "env": {}
      },
      "initialization_options": {},
      "settings": {}
    }
  }
}
```

If autocomplete does not appear, first verify that Zed can start the server, then check `zed: open log` for LSP startup errors. Repeated `mojo-lsp-server failed: server shut down` messages mean the server process exited and Zed is still draining stale requests; reload the window to restart it.

## Snippets

The extension includes snippets for common Mojo forms such as `fn main`, `def main`, `struct`, `trait`, `alias`, `var`, loops, conditionals, and tests. They are stored in `snippets/mojo.json` and appear alongside normal completion items.

## Running Mojo files from Zed

Zed runs code through Tasks. This extension marks `def main` / `fn main` as a runnable with the tag `mojo-main` and ships a default language task in `languages/mojo/tasks.json`:

```json
[
  {
    "label": "mojo run current file",
    "command": "mojo",
    "args": ["run", "$ZED_FILE"],
    "cwd": "$ZED_WORKTREE_ROOT",
    "save": "current",
    "use_new_terminal": false,
    "allow_concurrent_runs": false,
    "reveal": "always",
    "hide": "never",
    "tags": ["mojo-main"]
  }
]
```

After installing or updating the dev extension, reload Zed with `zed: reload window` and reopen a `.mojo` file. The inline runnable indicator should appear next to `def main` / `fn main` when `gutter.runnables` is enabled.

You can override the default action in a Mojo project's `.zed/tasks.json`, or globally via `zed: open tasks`, by defining your own task with `"tags": ["mojo-main"]`.

This assumes the `mojo` executable is available in the shell environment that Zed uses. If Zed cannot find it, launch Zed from a terminal where `mojo --version` works, or add Mojo to your shell `PATH`.

## Development

Run the native Rust checks:

```sh
cargo fmt --check
cargo check
```

Zed compiles Rust extensions to WebAssembly. To check that target locally, install it once and run the target check:

```sh
rustup target add wasm32-wasip1
cargo check --target wasm32-wasip1
```

Run the extension query and snippet checks:

```sh
bash scripts/check-snippets.sh
bash scripts/check-indents.sh
bash scripts/check-highlight-order.sh
bash scripts/check-runnables.sh
```

`extension.wasm` is a generated build artifact and is intentionally ignored by git.
