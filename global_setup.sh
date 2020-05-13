#!/bin/bash
user=$(git config --global user.name)
email=$(git config --global user.email)
editor="nano"

read -p "Git user name [$user]: " new_user
read -p "Git email [$email]: " new_email
if [[ ! -z $new_user ]] && [[ $new_user != $user ]]; then
    $(git config --global --replace-all user.name "$new_user")
fi;

if [[ ! -z $new_email ]] && [[ $new_email != $email ]]; then
    $(git config --global --replace-all user.email "$new_email")
fi;

read -p "Git editor [nano]: " new_editor
if [[ -z $new_editor ]]; then
    new_editor="$editor"
fi;
$(git config --global --replace-all core.editor "$new_editor")

read -p "Do you want to include a global .gitignore file? [Y/n]: " gitignore
if [[ -z $gitignore ]] || [[ $gitignore == "Y" ]]; then
    $(echo "## macOS" > ~/.gitignore_global)
    $(echo ".DS_Store" >> ~/.gitignore_global)
    $(echo "" >> ~/.gitignore_global)
    $(git config --global --replace-all core.excludesfile ~/.gitignore_global)
fi;

echo "The next alias will be installed:"
echo "  tip:     show tips and recipes for git"
echo "  cleanup: remove already merged branches in master and dev*"

read -p "Do you want to add these aliases? [Y/n]: " alias
if [[ -z $alias ]] || [[ $alias == "Y" ]]; then
    $(git config --global alias.tip "!bash $(pwd)/tips.sh")
    $(git config --global alias.cleanup "!git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d")
fi;

echo "Current Git global configuration:"
echo "$(git config --global -l)"
echo ""
echo "If you want to edit the configuration, please run:"
echo "  $new_editor ~/.gitconfig"
echo ""
echo "And if you want to edit the .gitignore_global file, please run:"
echo "  $new_editor ~/.gitignore_global"
echo ""
