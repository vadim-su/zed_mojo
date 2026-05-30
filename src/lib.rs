use zed_extension_api::{self as zed, Result};

const LANGUAGE_SERVER_ID: &str = "mojo-lsp-server";
const SERVER_NAME: &str = "mojo-lsp-server";
const DEFAULT_ARGS: &[&str] = &["--skip-docstring-checks"];

struct MojoExtension;

impl zed::Extension for MojoExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let lsp_settings =
            zed::settings::LspSettings::for_worktree(language_server_id.as_ref(), worktree)?;

        let binary = lsp_settings.binary;
        let mut args = DEFAULT_ARGS
            .iter()
            .map(|arg| arg.to_string())
            .collect::<Vec<_>>();
        let mut env = worktree.shell_env();
        let binary_path = binary
            .as_ref()
            .and_then(|binary| binary.path.as_deref())
            .unwrap_or(SERVER_NAME)
            .to_string();

        if let Some(binary) = binary {
            if let Some(arguments) = binary.arguments {
                args.extend(arguments);
            }

            if let Some(binary_env) = binary.env {
                env.extend(binary_env);
            }
        }

        let command = if binary_path.contains('/') {
            binary_path
        } else {
            worktree
                .which(&binary_path)
                .ok_or_else(|| format!("{binary_path} must be available in PATH"))?
        };

        Ok(zed::Command { command, args, env })
    }

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        if language_server_id.as_ref() != LANGUAGE_SERVER_ID {
            return Ok(None);
        }

        zed::settings::LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .map(|settings| settings.initialization_options)
    }

    fn language_server_workspace_configuration(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<zed::serde_json::Value>> {
        if language_server_id.as_ref() != LANGUAGE_SERVER_ID {
            return Ok(None);
        }

        zed::settings::LspSettings::for_worktree(language_server_id.as_ref(), worktree)
            .map(|settings| settings.settings)
    }
}

zed::register_extension!(MojoExtension);
