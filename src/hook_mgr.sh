#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$here/extract_related_hooks.sh"

toolset_local=$(pwd)/.git/git-toolset
path_to_config=$toolset_local/.config
hook_name="$@"

if [ ! -f "$path_to_config" ]; then
  exit
fi

candidates=$(extract_related_hooks $path_to_config $hook_name);

for candidate in $candidates; do
    IFS="="
    read -ra splitted <<< "$candidate"
    hook_name=${splitted[0]}
    path=${splitted[1]}
    echo "Running hook $hook_name:"
    $($toolset_local/$path)
    if [ $? != 0 ]; then
        echo "Hook $hook_name failed. Aborting."
        exit 1
    fi
    echo "Done."
done
