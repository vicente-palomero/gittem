#!/bin/bash

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$here/lib/dialog.sh"

project=$1

#should check if .git folder exists
if [ ! -d "$project" ]; then
  # Take action if $DIR exists. #
  dialog::err "[$project] is not a GIT repository, exiting."
  exit 1
fi

project_git="$project/.git"
config_path="$project/.git/git-toolset"
config_file="$config_path/.config"

dialog::say "Creating [$config_file]"
mkdir -p $config_path
cp $here/sample/hooks.ini.sample $config_file

dialog::say "Installing hooks library"
config_hooks_lib_path="$project/.git/git-toolset/"
cp -r $here/hooks $config_hooks_lib_path

dialog::say "Run git init for copying hook templates"
git init

dialog::say "Git-tools/hooks mgr setup correctly."

