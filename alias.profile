#!/bin/sh

# dev tools --------------------------------------------------------------------
alias zshconfig='vim ~/.zshrc'
alias fishconfig='vim ~/.config/fish/config.fish'
alias sshconfig='vim ~/.ssh/config'
alias gm='git commit -m'
alias duhid='du -sh .[^.]*'
alias tf='tail -f'

alias prj='cd $prj'
alias lst='cd $lst'

# assume adaptive_alias defined, syntax: adaptive_alias better_cmd fallback_cmd
# if better_cmd exists, alias fallback_cmd to better_cmd
adaptive_alias "vim" "vi"
adaptive_alias "bat" "cat"
adaptive_alias "podman" "docker"
adaptive_alias "tldr" "eg"

# python -----------------------------------------------------------------------
alias py='python3'
alias pyconfig='vim pyproject.toml'
alias va='source .venv/bin/activate'
alias vd='deactivate'

alias pp='export PYTHONPATH=$(pwd)'

alias ff='ruff format'
alias ffi='ruff check --select I --fix'
alias hfdata='hf download --repo-type dataset'

# slurm ------------------------------------------------------------------------
export SQUEUE_FORMAT="%.10i %.5P %.30j %.10u %.2t %.12M %.2D %R"
export SACCT_FORMAT="JobID%-10,JobName%-30,State,ExitCode,Start,End,Elapsed,NodeList,WorkDir%30"

alias scc='scancel'
alias sq='squeue'
alias sd='scontrol show jobid -d'
alias usq="squeue -u $USER"
alias slist="sacct -u $USER -X -S now-3days"
alias shist='slist | head -n 2; slist -n | sort -k 5 -r' # sorted by start time
alias slast='slist | head -n 2; slist -n | sort -k 6 -r' # sorted by end time
alias sl="python $CUSTOM/findlog.py"
alias sll="sl --local"
alias sb="sbatch"
