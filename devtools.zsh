# --- collection of some dev tools ---
alias zshconfig='vim ~/.zshrc'
alias sshconfig='vim ~/.ssh/config'

alias duhid='du -sh .[^.]*'
alias duall='du -sh *'

if command -v podman &> /dev/null; then
	alias docker=podman
fi
if command -v tldr &> /dev/null; then
	alias eg=tldr
fi
if command -v zoxide &> /dev/null; then
	eval "$(zoxide init zsh)"
else
    alias z=cd
fi

pub() {
	if [ $# -ne 1 ]; then
		echo "Usage: $0 <directory>"
		echo "  Recursively chmod 777 dir/**/subdirs and 744 dir/**/subfiles."
		exit 1
	fi

	local dir="$1"
	# Check if the directory exists
	if [ ! -d "$dir" ]; then
		echo "Error: not dir '$dir'."
		return 1
	fi

	# Use find to recursively process the directory

	find "$dir" -type d -print0 | while IFS= read -r -d $'\0' subdir; do
		chmod 777 "$subdir"
		if [ $? -ne 0 ]; then
			echo "Error: Failed to chmod 777 '$subdir'"
		fi
	done

	find "$dir" -type f -print0 | while IFS= read -r -d $'\0' subfile; do
		chmod 744 "$subfile"
		if [ $? -ne 0 ]; then
			echo "Error: Failed to chmod 744 '$subfile'"
		fi
	done

	echo "finished publishing '$dir': 777 subdirs, 744 subfiles."
	return 0
}
