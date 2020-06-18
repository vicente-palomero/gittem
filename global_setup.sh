#!/bin/bash
toolset_home="$(dirname "$(readlink -f "$0")")"

source  "$toolset_home/src/dialogs.sh"

function write_hook () {
    if [ -f "$1/$2" ]; then
        if [ $(grep "git hook" $1/$2 | wc -l) == 0 ]; then
            echo "git hook \"$2\"" >> $1/$2
        fi
    else
        echo "#!/bin/sh

git hook \"$2\"" > $1/$2
    chmod u+x $1/$2
    fi
}

say "Steps included in this script:"

cat $0 | grep '\[STEP' | grep -v "cat" | sed 's/say //' | sed 's/\"//g' | sed 's/\[/\t - [/'

say "[STEP 1] Setting git user name and password"

user=$(git config --global user.name)
email=$(git config --global user.email)
editor="nano"

new_user=$(fill "Git user name [$user]:")
if [[ ! -z $new_user ]] && [[ $new_user != $user ]]; then
    $(git config --global --replace-all user.name "$new_user")
fi;


new_email=$(fill "Git email [$email]:")

if [[ ! -z $new_email ]] && [[ $new_email != $email ]]; then
    $(git config --global --replace-all user.email "$new_email")
fi;


new_editor=$(fill "Git editor [nano]:")
if [[ -z $new_editor ]]; then
    new_editor="$editor"
fi;
$(git config --global --replace-all core.editor "$new_editor")

say "[STEP 2] Including global .gitignore file"

gitignore=$(ask "Do you want to include a global .gitignore file?")

if [[ -z $gitignore ]] || [[ $gitignore == "y" ]]; then
    $(echo "## macOS" > ~/.gitignore_global)
    $(echo ".DS_Store" >> ~/.gitignore_global)
    $(echo "" >> ~/.gitignore_global)
    $(echo "## Vim" >> ~/.gitignore_global)
    $(echo ".*.swp" >> ~/.gitattributes_global)
    $(echo ".*.swo" >> ~/.gitignore_global)
    $(echo "" >> ~/.gitignore_global)
    $(git config --global --replace-all core.excludesfile ~/.gitignore_global)
fi;

say "[STEP 3] Alias installation"

echo "The next alias will be installed:"
echo "  tip:     show tips and recipes for git"
echo "  cleanup: remove already merged branches in master and dev*"
echo "  hook:    enable git-config hooks manager as git alias"
alias=$(ask "Do you want to add these aliases?:")
echo $alias

if [[ -z $alias ]] || [[ $alias == "y" ]]; then
    $(git config --global alias.tip "!bash $toolset_home/tips.sh");
    $(git config --global alias.cleanup "!git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d");
    $(git config --global alias.hook "!bash $toolset_home/hook_mgr.sh")
fi;

say "[STEP 4] Git prompt installation"
prompt=$(ask "Change the prompt for showing the branch you are working on? (Requires writing on your .bashrc file)")

if [[ -z $prompt ]] || [[ $prompt == "y" ]]; then
    $(echo "" >> ~/.bashrc)
    $(echo "# Add git branch in prompt (from git-tools)" >> ~/.bashrc)
    $(echo "parse_git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' ; }" >> ~/.bashrc)
    $(echo 'export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >> ~/.bashrc)
    $(echo "# End Add git branch in prompt from git-tools)" >> ~/.bashrc)
    $(echo "" >> ~/.bashrc) 
fi;

say "[STEP 5] Add git templatedir folder"
$(git config --global --replace-all init.templatedir '~/.git-templates')
hook_path=~/.git-templates/hooks
mkdir -p $hook_path

write_hook $hook_path "applypatch-msg"
write_hook $hook_path "commit-msg"
write_hook $hook_path "fsmonitor-watchman"
write_hook $hook_path "post-update"
write_hook $hook_path "pre-applypatch"
write_hook $hook_path "pre-commit"
write_hook $hook_path "pre-merge-commit"
write_hook $hook_path "prepare-commit-msg"
write_hook $hook_path "pre-push"
write_hook $hook_path "pre-rebase"
write_hook $hook_path "pre-receive"
write_hook $hook_path "update"

say "Current Git global configuration: \n\
***
$(git config --global -l) \n\
***
If you want to edit the configuration, please run: \n\
\t $new_editor ~/.gitconfig \n\

If you want to edit the .gitignore_global file, please run: \n\
\t $new_editor ~/.gitignore_global \n\

And if you need to reload your .bashrc file, please run: \n\
\t  source ~/.bashrc"
