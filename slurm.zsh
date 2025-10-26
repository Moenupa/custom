# --- useful slurm aliases ---
if ! command -v scontrol &> /dev/null; then
	return
fi

# better default formats
export SQUEUE_FORMAT="%.10i %.5P %.30j %.10u %.2t %.12M %.2D %R"
export SACCT_FORMAT="JobID%-10,JobName%-24,State,ExitCode,Start,End,Elapsed,NodeList,WorkDir%-10"

# shortcuts, should not conflict
sb() {
	local output jobid
	output=$(sbatch "$@")
	jobid=$(echo "$output" | awk '{print $4}')
	echo $output
	echo "$(sl $jobid)"
}
alias scc='scancel'
alias sq='squeue'
alias sd='scontrol show jobid -d'
alias usq="squeue -u $USER"
alias slist="sacct -u $USER -X -S now-3days"
# sorted by start time
alias shist="(slist | head -n 2; slist -n | sort -k 5 -r)"
# sorted by end time
alias slast="(slist | head -n 2; slist -n | sort -k 6 -r)"

sl() {
	# Parse options
	local show_stdout=0
	local show_stderr=0
	local jobids=()

	while [[ $# -gt 0 ]]; do
		case "$1" in
			--stdout|-o)
				show_stdout=1
				shift
				;;
			--stderr|-e)
				show_stderr=1
				shift
				;;
			*)
				jobids+=("$1")
				shift
				;;
		esac
	done

	if [[ ${#jobids[@]} -eq 0 ]]; then
		echo "Finds stdout and stderr for a slurm job"
		echo "Usage: $0 [-o|--stdout] [-e|--stderr] <jobid> [jobid2 ...]"
		return 1
	fi

	# Default: print stderr only if neither option is specified
	if [[ $show_stdout -eq 0 && $show_stderr -eq 0 ]]; then
		show_stderr=1
	fi

	local jobid jobinfo stdout stderr
	for jobid in "${jobids[@]}"; do
		if ! jobinfo=$(scontrol show job "$jobid" 2>/dev/null); then
			echo "Error: Could not find job $jobid" >&2
			continue
		fi

		if [[ $show_stdout -eq 1 ]]; then
			stdout=$(grep -oP 'StdOut=\K\S+' <<< "$jobinfo")
			echo -e "\e[44m$stdout\e[0m"
		fi
		if [[ $show_stderr -eq 1 ]]; then
			stderr=$(grep -oP 'StdErr=\K\S+' <<< "$jobinfo")
			echo -e "\e[41m$stderr\e[0m"
		fi
	done
}
sll() {
	if [ $# -eq 0 ]; then
		echo "Finds local logs with specified prefix, e.g. sll 12345 -> /path/to/12345.*"
		echo "Usage: $0 <filename> [filename2 filename3 ...]"
		return 2
	fi

	local jobid
	for jobid in "$@"; do
		find . -maxdepth 4 -type f -path "**/log*/**/$jobid*" 2>/dev/null
	done
}

# completion for slurm job ids
_slurm_jobids() {
	local expl
	local -a running
	running=(${(f)"$(squeue -u $USER -h -o '%A' 2>/dev/null)"})
	running=(${(u)running})

	local -a hist_jobs
	hist_jobs=(${(f)"$(sacct -u $USER -n -X -P -S now-3days -o JobID 2>/dev/null | grep -E '^[0-9]+')"})
	hist_jobs=(${(u)hist_jobs})

	if [[ -n $running ]]; then
		_wanted running expl 'Running Jobs' compadd -a running
	fi

	if [[ -n $hist_jobs ]]; then
		_wanted hist_jobs expl 'Past 3-day Jobs' compadd -a hist_jobs
	fi
}
_running_jobids() {
	local expl
	local -a jobids

	jobids=(${(f)"$(squeue -u $USER -h -o '%A' 2>/dev/null)"})
	jobids=(${(u)jobids})
	_arguments \
		'(-o --stdout)'{-o,--stdout}'[Show stdout]' \
		'(-e --stderr)'{-e,--stderr}'[Show stderr]' \
		'*:jobid:->jobids'
}

compdef _running_jobids sl
compdef _slurm_jobids sll
