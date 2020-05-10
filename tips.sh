#!/bin/bash

usage() {
  echo "Git quick tips"
  echo "=============="
  echo ""
  echo "Index of topics"
  echo "---------------"
  echo "  all       Show all tips"
  echo "  branch    Show tips related with branching"
  echo "  crud      Show how create, read, update or delete files"
  echo "  stage     Show tips related with staging and unstaging files"
  echo ""
  echo "Usage"
  echo "-----"
  echo "./tips.sh -i topic    for a topic from the previous list"
  echo "./tips.sh -a          for all topics"
  echo ""
  exit 1
}

branch() {
  echo "Branching tips"
  echo "=============="
  echo "Create a new branch:        git checkout -b <branch_name>"
  echo "Remove a branch:            git branch -d <branch_name>"
  echo ""
}

crud() {
  echo "Create, read, update, delete tips"
  echo "================================="
  echo "Rename a file:              git mv <prev_name> <new_name>"
  echo "Delete a file:              git rm <file>"
  echo ""
}

stage() {
  echo "Stage tips"
  echo "=========="
  echo "Stage file:                 git add <file>"
  echo "Unstage file:               git reset HEAD <file>"
  echo "Get status of stage:        git status"
  echo "Get unstaged changes:       git diff"
  echo "Get staged changes:         git diff --cached"
  echo ""
}

all() {
  branch
  crud
  stage
}

while getopts i:a o; do
  case $o in
    (i) which=$OPTARG;;
    (a) which="all";;
    (*) usage
  esac
done
shift "$((OPTIND -1))"

if [[ -z $which ]]; then
  usage;
fi

echo ""
case $which in
"branch") branch ;;
"crud") crud;;
"stage") stage ;;
"all") all ;;
*) echo "Topic $which is not supported." ;;

esac
