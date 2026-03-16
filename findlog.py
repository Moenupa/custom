#!/usr/bin/env python3
import argparse
import re
import subprocess
import sys
from glob import iglob
from os import path as osp

ERR_COLOR = "\033[41m"
OUT_COLOR = "\033[44m"
RESET_COLOR = "\033[0m"


def color_print(text: str, color: str, is_colored: bool):
    print(f"{color}{text}{RESET_COLOR}" if is_colored else text)


def get_slurm_info(
    jobid: int | str, show_stdout: bool, show_stderr: bool, colored: bool = False
):
    try:
        res = subprocess.run(
            ["scontrol", "show", "job", str(jobid)],
            capture_output=True,
            text=True,
            check=True,
        )
        info = res.stdout
    except subprocess.CalledProcessError:
        print(f"Error: no such job {jobid}", file=sys.stderr)
        return

    if show_stderr and (match := re.search(r"StdErr=(\S+)", info)):
        color_print(match.group(1), ERR_COLOR, colored)
    if show_stdout and (match := re.search(r"StdOut=(\S+)", info)):
        color_print(match.group(1), OUT_COLOR, colored)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Find stdout/stderr for Slurm Jobs.")
    as_bool = dict(action=argparse.BooleanOptionalAction)
    parser.add_argument("-c", "--color", **as_bool, default=True, help="Color output (default: true)")
    parser.add_argument("-e", "--stderr", **as_bool, default=True, help="Show stdERR (default: true)")
    parser.add_argument("-o", "--stdout", **as_bool, help="Show stdOUT (default: false)")
    parser.add_argument("-l", "--local", **as_bool, help="Use local or slurm search mode (default: slurm)")
    parser.add_argument("jobids", type=str, nargs="+", help="Job ID")
    args = parser.parse_args()

    if args.local:
        stdout_lookup = (
            {osp.basename(f): f for f in iglob("**/log*/**/*.out", recursive=True)}
            if args.stdout
            else {}
        )
        stderr_lookup = (
            {osp.basename(f): f for f in iglob("**/log*/**/*.err", recursive=True)}
            if args.stderr
            else {}
        )
        for jobid in args.jobids:
            if match := stdout_lookup.get(f"{jobid}.out"):
                color_print(match, OUT_COLOR, args.color)
            if match := stderr_lookup.get(f"{jobid}.err"):
                color_print(match, ERR_COLOR, args.color)
    else:
        for jobid in args.jobids:
            get_slurm_info(jobid, args.stdout, args.stderr, args.color)
