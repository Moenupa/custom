#!/usr/bin/env zsh
adaptive_alias () {
	if command -v "$1" &> /dev/null; then
		alias $2=$1
	fi
}

source $CUSTOM/alias.profile
export ZSH_THEME="headline"

if command -v zoxide &> /dev/null; then
	eval "$(zoxide init zsh)"
fi

# https://github.com/marlonrichert/zsh-autocomplete
zstyle ':autocomplete:*' min-input 3
zstyle ':autocomplete:*' delay 0.5
zstyle ':autocomplete:*' list-prompt ''
zstyle ':autocomplete:*' select-prompt ''
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char

# https://github.com/zsh-users/zsh-autosuggestions
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

if [ -f "$CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
    source "$CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi
if [ -f "$HOME/.template/init.zsh" ]; then
    source "$HOME/.template/init.zsh"
fi
