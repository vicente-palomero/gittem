#!/bin/bash

function cleanInput() {
    echo $1 | sed "s/'//g"
}


function version(){
  echo "Git toolset version 0.0.1"
}

function usage(){
  echo "$(basename $0) [-h] -- Git hooks manager and tipper.
    where
      -h --help     Show this help.
      -g --global   Runs global configuration script.
      -i --install  Installs hooks (calls hook_installer.sh with the path set as parameter).
      -t --tips     Shows all tips.
      -b --branch   Shows branch-related all tips.
      -c --crud     Shows crud-related all tips.
      -s --stage    Shows stage-related all tips.
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
    usage;
    exit;
fi

set -- $options

while [ $# -gt 0 ]
do
    case $1 in
    -g|--global) ./global_setup.sh;;
    -h|--help) usage ;;
    -i|--install) ./hooks_installer.sh -r `cleanInput $3`;;
    -t|--tips) ./tips.sh -a;;
    -b|--branch) ./tips.sh -i branch;;
    -c|--crud) ./tips.sh -i crud;;
    -s|--stage) ./tips.sh -i stage;;
    -v|--version) version ;;
    (--) shift;break;;
    (-*) echo "$0: error - unrecognized option $2" 1>&2; exit 1;;
    (*)  break;;
    esac
    shift
done
