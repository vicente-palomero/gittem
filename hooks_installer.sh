#!/bin/bash

PROGNAME=$0

usage() {
  cat << EOF >&2
Usage: $PROGNAME -r <path> [-h]

-r <path>: The path of the repository where you want to add these hooks.
-h       : Show this usage guide.
EOF
  exit 1
}

while getopts r:h o; do
  case $o in
    (r) repo=$OPTARG;;
    (h) usage;;
    (*) usage
  esac
done
shift "$((OPTIND - 1))"

if [[ -z $repo ]]; then usage; fi;

if [[ ! -d $repo ]]; then
  echo "The directory $repo does not exist"
  exit 1
fi

if [ ! -d $repo/.git ]; then
  echo "This is not a git project"
  exit 1
fi

echo "
List of available hoooks
========================

Commit-msg hooks:
----------------
Issue-reference: Check if a reference of an issue is included in the commit message.

"
read -p "You want to install the commit-msg hooks? [Y/n]: " msg
if [[ -z $msg ]] || [[ $msg == "Y" ]]; then
  echo '#!/usr/bin/env bash

input_file=$1
start_line="head -n1 $input_file"
regex="\[[0-9]{,9}\]"
found=0

if [[ ! $found ]] || [[ ! $start_line =~ $regex ]]; then
  echo "
Your current message is: $start_line

Issue reference is required for syncing.
  Example: [12345678] issue title or commit message

If you want to avoid this verification step, please run git commit with --no-verify

Aborting."
  exit 1
fi;
  ' > $repo/.git/hooks/commit-msg
  $(/bin/chmod u+x $repo/.git/hooks/commit-msg)
  echo "Done."
fi;
