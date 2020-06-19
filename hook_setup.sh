#!/bin/bash
toolset_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "$toolset_home/src/dialogs.sh"

project=$1

#should check if .git folder exists
if [ ! -d "$project" ]; then
  # Take action if $DIR exists. #
    err "[$project] is not a GIT repository, exiting."
    exit 1
fi

project_git="$project/.git"
config_path="$project/.git/git-toolset"
config_file="$config_path/.config"
say "Creating [$config_file]"
mkdir -p $config_path
cp $toolset_home/sample/hooks.ini.sample $config_file

say "Installing hooks library"
config_hooks_lib_path="$project/.git/git-toolset/hooks"
cp -r $toolset_home/hooks $config_hooks_lib_path

say "Run git init for copying hook templates"
git init

say "Git-tools/hooks mgr setup correctly."


