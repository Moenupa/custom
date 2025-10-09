#!/bin/sh
# gen shell completions
uv generate-shell-completion zsh > $ZSH_CUSTOM/completions/_uv
uvx --generate-shell-completion zsh > $ZSH_CUSTOM/completions/_uvx
ruff generate-shell-completion zsh > $ZSH_CUSTOM/completions/_ruff