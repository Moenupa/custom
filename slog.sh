#!/bin/sh
# slog - Find stdout / stderr for Slurm jobs (POSIX / dash)
_slog_help() {
	printf 'Usage: slog [options] jobid [...]\n' >&2
	printf 'Options:\n' >&2
	printf '  -c, --color         Enable colour output (default)\n' >&2
	printf '      --no-color      Disable colour output\n' >&2
	printf '  -e, --stderr        Show StdErr paths (default)\n' >&2
	printf '  -o, --stdout        Show StdOut paths\n' >&2
	printf '  -a, --all           Show both StdOut and StdErr paths\n' >&2
	printf '  -l, --local         Search for local logs instead of asking Slurm (default: false)\n' >&2
	return 0
}

slog() {
	color=1
	show_stderr=1
	show_stdout=0
	local_mode=0

	ERR_COLOR='\033[41m'   # red background
	OUT_COLOR='\033[44m'   # blue background
	RESET_COLOR='\033[0m'

	color_print() {
		# $1 = text, $2 = colour escape, $3 = colour‑enabled flag (1/0)
		if [ "$3" -eq 1 ] && [ -t 1 ]; then
			printf '%b%s%b\n' "$2" "$1" "$RESET_COLOR"
		else
			printf '%s\n' "$1"
		fi
	}

	while [ $# -gt 0 ]; do
		case "$1" in
			-c|--color)        color=1 ;;
			--no-color)        color=0 ;;
			-e|--stderr)       show_stderr=1; show_stdout=0 ;;
			-o|--stdout)       show_stderr=0; show_stdout=1 ;;
			-a|--all)          show_stderr=1; show_stdout=1 ;;
			-l|--local)        local_mode=1 ;;
			--)                shift; break ;;
			-*)                printf 'Unknown option: %s\n' "$1" >&2; return 1 ;;
			*)                 break ;;
		esac
		shift
	done

	if [ $# -eq 0 ]; then
		_slog_help
		return 1
	fi

	if [ "$local_mode" -eq 1 ]; then
		for jobid; do
			if [ "$show_stderr" -eq 1 ]; then
				err_path=$(find log* -maxdepth 4 -type f -name "${jobid}.err" -print -quit 2>/dev/null)
				[ -n "$err_path" ] && color_print "$err_path" "$ERR_COLOR" "$color"
			fi
			if [ "$show_stdout" -eq 1 ]; then
				out_path=$(find log* -maxdepth 4 -type f -name "${jobid}.out" -print -quit 2>/dev/null)
				[ -n "$out_path" ] && color_print "$out_path" "$OUT_COLOR" "$color"
			fi
		done
		return 0
	fi

	for jobid; do
		jobinfo=$(scontrol show job "$jobid" 2>/dev/null)
		if [ $? -ne 0 ] || [ -z "$jobinfo" ]; then
			printf 'Error: no such job %s\n' "$jobid" >&2
			continue
		fi

		if [ "$show_stderr" -eq 1 ]; then
			err=$(printf '%s\n' "$jobinfo" |
					awk -v RS=' ' '
						$0 ~ /^StdErr=/ {
							sub(/^StdErr=/, "")
							print; exit
						}')
			[ -n "$err" ] && color_print "$err" "$ERR_COLOR" "$color"
		fi
		if [ "$show_stdout" -eq 1 ]; then
			out=$(printf '%s\n' "$jobinfo" |
					awk -v RS=' ' '
						$0 ~ /^StdOut=/ {
							sub(/^StdOut=/, "")
							print; exit
						}')
			[ -n "$out" ] && color_print "$out" "$OUT_COLOR" "$color"
		fi
	done
}

if [ -z "${BASH_SOURCE-}" ] && [ -z "${ZSH_EVAL_CONTEXT-}" ]; then
	slog "$@"
fi
