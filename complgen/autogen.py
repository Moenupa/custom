import os.path as osp
import subprocess
import sys
from functools import partial
from glob import glob

# usage/ and completions/ are parallel
COMPLGEN_SRC_DIR = osp.dirname(__file__)
COMPLETION_DIR = f"{osp.dirname(COMPLGEN_SRC_DIR)}/completions"
DRY_RUN = False

__doc__ = f"""
Generate completion scripts for bash, zsh and fish using complgen
(https://github.com/adaszko/complgen/blob/master/README.md).
Please make sure `complgen` is installed and available in your PATH.

Usage: python {sys.argv[0]}

Completion will be saved to {COMPLETION_DIR} directory.
"""


def get_filename_wo_ext(filename: str) -> str:
    return osp.splitext(osp.basename(filename))[0]


def handle_completion(usage_file: str, mapper_fn, dry_run: bool = DRY_RUN):
    cmd = mapper_fn(usage_file)
    if dry_run:
        print(f"🌵: {cmd}")
        return

    ret = subprocess.call(cmd, shell=True)
    if ret:
        print(f"🚫: {usage_file}")
    else:
        print(f"✅: {cmd}")

def map_bash_cmd(usage_file: str) -> str:
    return f"complgen --bash {COMPLETION_DIR}/{get_filename_wo_ext(usage_file)}.bash {usage_file}"

def map_zsh_cmd(usage_file: str) -> str:
    return f"complgen --zsh {COMPLETION_DIR}/_{get_filename_wo_ext(usage_file)} {usage_file}"

def map_fish_cmd(usage_file: str) -> str:
    return f"complgen --fish {COMPLETION_DIR}/{get_filename_wo_ext(usage_file)}.fish {usage_file}"


if __name__ == "__main__":
    # if complgen is not installed, help
    if ret_value := subprocess.call("command -v complgen > /dev/null 2>&1", shell=True):
        print(__doc__)
        exit(ret_value)

    usage_files = glob(f"{COMPLGEN_SRC_DIR}/*.usage")
    list(map(partial(handle_completion, mapper_fn=map_bash_cmd), usage_files))
    list(map(partial(handle_completion, mapper_fn=map_zsh_cmd), usage_files))
    list(map(partial(handle_completion, mapper_fn=map_fish_cmd), usage_files))
