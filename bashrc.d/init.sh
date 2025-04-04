#!/bin/bash

# Load all scripts from ~/.bashrc.d/ if not already
if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME/.bashrc.d/"*.sh; do
        # Skip init.sh to avoid recursion
        [[ "$(basename "$rc")" != "init.sh" && -r "$rc" ]] && . "$rc"
    done
fi
