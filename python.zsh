# --- for python dev ---
if ! command -v python3 &> /dev/null && ! command -v uv &> /dev/null; then
	return
fi

alias py='python3'
alias va='conda activate'
alias vd='conda deactivate'
alias vva='source .venv/bin/activate'
alias vvd='deactivate'
alias hfdataset='hf download --repo-type dataset'

if command -v ruff &> /dev/null; then
	alias ff='ruff format'
	alias ffi='ruff check --select I --fix'
fi
if command -v pre-commit &> /dev/null; then
	alias pc='pre-commit'
fi

pp() {
	export PYTHONPATH=$(pwd)
}
fserver() {
	PORT=${1:-80}
	ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}'
	python3 -m http.server $PORT
}
