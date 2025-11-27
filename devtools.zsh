# --- collection of some dev tools ---
alias zshconfig='vim ~/.zshrc'
alias sshconfig='vim ~/.ssh/config'

alias duhid='du -sh .[^.]*'

alias tf='tail -f'

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

# # Function to prepend directories to PATH if not already present
# prepend_path() {
#     # $1: existing PATH
#     # $@: directories to prepend (from $2 onwards)
#     local new_path="$1"
#     shift
#     for dir in "$@"; do
#         case ":${new_path}:" in
#             *:"$dir":*)
#                 # already present, skip
#                 ;;
#             *)
#                 new_path="$dir:$new_path"
#                 ;;
#         esac
#     done
#     echo $new_path
# }
