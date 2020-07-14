#!/bin/bash
#
# Main script for git-toolset

toolset_home="$(dirname "$(readlink -f "$0")")"
source "${toolset_home}/src/lib/io.sh"

function version() {
  echo "Git toolset version 0.1.0"
}

function usage(){
  echo "$(basename $0) [-h] -- Git hooks manager and tipper.
    where
      -h --help     Show this help.
      -g --global   Runs global configuration script.
      -i --install  Installs hooks in the current project folder.
      -v --version  Shows the current version.
  "
}

# options may be followed by one colon to indicate they have a required argument
if ! options=$(getopt -o bcghistv -l branch,crud,global,help,install,stage,tips,vesion  -- "$@")
then
  # something went wrong, getopt will put out an error message for us
  exit 1
fi

if [ $# -eq 0 ]; then
  echo "No arguments provided."
  usage
  exit
fi

set -- $options

while [ $# -gt 0 ]
do
  case $1 in
    -g|--global) ${toolset_home}/src/global_setup.sh;;
    -h|--help) usage ;;
    -i|--install) ${toolset_home}/src/hook_setup.sh $(io::clean $(pwd)) ;;
    -v|--version) version ;;
    --) shift;break;;
    -*) echo "$0: error - unrecognized option $2" 1>&2; exit 1;;
    *)  break;;
  esac
  shift
done

