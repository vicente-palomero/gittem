#!/bin/bash

here=$(pwd)

# GIT_TOOLSET_HOME='/home/luis/Documentos/GitHub/git-toolset/'
GIT_TOOLSET_HOME=$(pwd)
source "$GIT_TOOLSET_HOME/./src/extract_related_hooks.sh"

#path_to_file="$(pwd)/.git/git-toolset/.config"
path_to_file=$(pwd)/hooks.ini
hook_name="$@"

candidates=$(extract_related_hooks $path_to_file $hook_name);

for candidate in $candidates; do
    IFS="="
    read -ra splitted <<< "$candidate"
    hook_name=${splitted[0]}
    path=${splitted[1]}
    echo "Running hook $hook_name:"
    $path
    echo "Done."
done
