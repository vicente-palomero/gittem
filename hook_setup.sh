#!/bin/bash
source "./src/dialogs.sh"

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
cp sample/hooks.ini.sample $config_file

say "Installing hooks library"
config_hooks_lib_path="$project/.git/git-toolset/hooks"
cp -r hooks $config_hooks_lib_path

say "Enabling pre-commit hooks"

echo '#!/bin/sh

git hook "$@" pre-commit' > $project_git/hooks/pre-commit
chmod u+x $project_git/hooks/pre-commit


say "Git-tools/hooks mgr setup correctly."
