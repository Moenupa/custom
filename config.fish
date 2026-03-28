#!/usr/bin/env fish
if status is-interactive
	fish_vi_key_bindings

	function adaptive_alias
		if command -v "$argv[1]" &> /dev/null
			alias $argv[2]=$argv[1]
		end
	end

	source $CUSTOM/alias.profile
	# override some aliases for fish
	alias va='source .venv/bin/activate.fish'
	alias slog='sh $CUSTOM/slog.sh'
	alias template='sh $TEMPLATE_DIR/tp.sh'

	if command -v zoxide &> /dev/null
		zoxide init fish | source
	end
end
