#!/bin/bash

usage() {
  echo "Git quick tips"
  echo "=============="
  echo ""
  echo "Index of topics"
  echo "---------------"
  echo "  all       Show all tips"
  echo "  branch    Show tips related with branching"
  echo "  changelog Show tips related with changelog events"
  echo "  crud      Show how create, read, update or delete files"
  echo "  revert    Show how to revert some git actions"
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
  echo -e "\033[1mBranching\033[0m tips"
  echo "=============="
  echo "Create a new branch:        git checkout -b <branch_name>"
  echo "Rename a branch:            git branch -m <branch_name>"
  echo "Remove a branch:            git branch -d <branch_name>"
  echo ""
}

crud() {
  echo -e "\033[1mCreate, read, update, delete\033[0m tips"
  echo "================================="
  echo "Rename a file:              git mv <prev_name> <new_name>"
  echo "Delete a file:              git rm <file>"
  echo ""
}

stage() {
  echo -e "\033[1mStage\033[0m tips"
  echo "=========="
  echo "Stage file:                 git add <file>"
  echo "Unstage file:               git reset HEAD <file>"
  echo "Get status of stage:        git status"
  echo "Get unstaged changes:       git diff"
  echo "Get staged changes:         git diff --cached"
  echo ""
}

changelog() {
  echo -e "\033[1mChangelog-related\033[0m tips (https://keepachangelog.com/en/1.1.0/)"
  echo "=========="
  echo "Guiding principles:"
  echo "-  Changelogs are for humans, not machines."
  echo "-  There should be an entry for every single version."
  echo "-  The same types of changes should be grouped."
  echo "-  Versions and sections should be linkable."
  echo "-  The latest version comes first."
  echo "-  The release date of each version is displayed."
  echo "-  Mention whether you follow Semantic Versioning."
  echo "=========="
  echo -e "Types of changes"
  echo -e "-  \033[4mAdded\033[0m for new features."
  echo -e "-  \033[4mChanged\033[0m for changes in existing functionality."
  echo -e "-  \033[4mDeprecated\033[0m for soon-to-be removed features."
  echo -e "-  \033[4mRemoved\033[0m for now removed features."
  echo -e "-  \033[4mFixed\033[0m for any bug fixes."
  echo -e "-  \033[4mSecurity\033[0m in case of vulnerabilities."
  echo ""
}

revert() {
  echo -e "\033[1mReverting actions\033[0m"
  echo "================="
  echo "Revert 'git add':                              git reset HEAD <file>"
  echo "Revert 'git commit (keep staging)':            git reset HEAD~1 --soft"
  echo "Revert 'git commit (unkeep staging)':          git reset HEAD~1"
  echo "Revert 'git push (keeping history, SAFER)':    git revert <unwanted commit hash>; git push"
  echo "Revert 'git push (changing history, UNSAFER)': git reset --hard <valid hash id>; git push --force"
  echo ""
  echo "Disclaimer: There are multiple ways for doing these actions. Be careful with all this stuff"
}

all() {
  branch
  crud
  changelog
  revert
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
"changelog") changelog ;;
"revert") revert;;
"stage") stage ;;
"all") all ;;
*) echo "Topic $which is not supported." ;;

esac
