#!/bin/bash

toolset_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$toolset_home/src/extract_related_hooks.sh"
path_to_file=$(pwd)/.git/git-toolset/.config
hook_name="$@"

candidates=$(extract_related_hooks $path_to_file $hook_name);

for candidate in $candidates; do
    IFS="="
    read -ra splitted <<< "$candidate"
    hook_name=${splitted[0]}
    path=${splitted[1]}
    echo "Running hook $hook_name:"
    $path
    if [ $? != 0 ]; then
        echo "Hook $hook_name failed. Aborting."
        exit 1
    fi
    echo "Done."
done
