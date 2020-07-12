#!/bin/bash
#
# Useful information for git

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${here}/lib/tip.sh"

while getopts i:a o; do
  case "${o}" in
    i) which=${OPTARG};;
    a) which="all";;
    *) tip::usage
  esac
done
shift "$((OPTIND - 1))"

if [[ -z ${which} ]]; then
  tip::usage;
fi

echo ""
case ${which} in
  "branch") tip::branch ;;
  "crud") tip::crud;;
  "changelog") tip::changelog ;;
  "revert") tip::revert;;
  "stage") tip::stage ;;
  "all") tip::all ;;
  *) echo "Topic ${which} is not supported." ;;
esac
