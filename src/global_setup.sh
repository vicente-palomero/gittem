#!/bin/bash
#
# Set up global configuration of git

here="$(dirname "$(readlink -f "$0")")"
source  "${here}/lib/dialog.sh"

function main() {
  next_steps

  step_basic_config "[STEP 1] Setting git user name and password"
  step_gitignore "[STEP 2] Including global .gitignore file"
  step_alias "[STEP 3] Alias installation"
  step_prompt "[STEP 4] Git prompt installation"
  step_templatedir "[STEP 5] Add git templatedir folder"

  summary
}

function write_hook() {
  local hook_path hook_name

  hook_path=$1
  hook_name=$2

  if [ -f "${hook_path}/${hook_name}" ]; then
    if [ $(grep "git hook" ${hook_path}/${hook_name} | wc -l) == 0 ]; then
      echo "git hook \"${hook_name}\"" >> ${hook_path}/${hook_name}
    fi
  else
    echo "#!/bin/sh

git hook \"${hook_path}\"" > ${hook_path}/${hook_name}
    chmod u+x ${hook_path}/${hook_name}
  fi
}

function step_basic_config() {
  local message
  messsage=$1

  dialog::say "${message}"

  user=$(git config --global user.name)
  email=$(git config --global user.email)
  editor="nano"

  new_user=$(dialog::fill "Git user name [${user}]:")
  if [[ ! -z ${new_user} ]] && [[ ${new_user} != ${user} ]]; then
      $(git config --global --replace-all user.name "${new_user}")
  fi;

  new_email=$(dialog::fill "Git email [${email}]:")
  if [[ ! -z ${new_email} ]] && [[ ${new_email} != ${email} ]]; then
      $(git config --global --replace-all user.email "${new_email}")
  fi;

  new_editor=$(dialog::fill "Git editor [nano]:")
  if [[ -z ${new_editor} ]]; then
      new_editor="$editor"
  fi;
  $(git config --global --replace-all core.editor "${new_editor}")
}

function step_gitignore() {
  local gitignore
  local message

  message=$1
  dialog::say "${message}"

  readonly gitignore=$(dialog::ask "Do you want to include a global .gitignore file?")

  if [[ -z ${gitignore} ]] || [[ ${gitignore} == "y" ]]; then
    $(echo "## macOS" > ~/.gitignore_global)
    $(echo ".DS_Store" >> ~/.gitignore_global)
    $(echo "" >> ~/.gitignore_global)
    $(echo "## Vim" >> ~/.gitignore_global)
    $(echo ".*.swp" >> ~/.gitignore_global)
    $(echo ".*.swo" >> ~/.gitignore_global)
    $(echo "" >> ~/.gitignore_global)
    $(git config --global --replace-all core.excludesfile ~/.gitignore_global)
  fi;
}

function step_alias() {
  local message

  message=$1
  dialog::say "${message}"

  echo "The next alias will be installed:"
  echo "  tip:     show tips and recipes for git"
  echo "  cleanup: remove already merged branches in master and dev*"
  echo "  hook:    enable git-config hooks manager as git alias"
  alias=$(dialog::ask "Do you want to add these aliases?:")
  echo ${alias}

  if [[ -z ${alias} ]] || [[ ${alias} == "y" ]]; then
    $(git config --global alias.tip "!bash $here/tips.sh");
    $(git config --global alias.cleanup "!git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d");
    $(git config --global alias.hook "!bash $here/hook_mgr.sh")
  fi;
}

function step_prompt() {

  prompt=$(dialog::ask "Change the prompt for showing the branch you are working on? (Requires writing on your .bashrc file)")

  if [[ -z ${prompt} ]] || [[ ${prompt} == "y" ]]; then
    $(echo "" >> ~/.bashrc)
    $(echo "# Add git branch in prompt (from git-tools)" >> ~/.bashrc)
    $(echo "parse_git_branch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' ; }" >> ~/.bashrc)
    $(echo 'export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >> ~/.bashrc)
    $(echo "# End Add git branch in prompt from git-tools)" >> ~/.bashrc)
    $(echo "" >> ~/.bashrc) 
  fi;
}

function step_templatedir() {
  local message

  message=$1
  dialog::say "${message}"

  $(git config --global --replace-all init.templatedir '~/.git-templates')
  hook_path=~/.git-templates/hooks
  mkdir -p ${hook_path}

  write_hook ${hook_path} "applypatch-msg"
  write_hook ${hook_path} "commit-msg"
  write_hook ${hook_path} "fsmonitor-watchman"
  write_hook ${hook_path} "post-update"
  write_hook ${hook_path} "pre-applypatch"
  write_hook ${hook_path} "pre-commit"
  write_hook ${hook_path} "pre-merge-commit"
  write_hook ${hook_path} "prepare-commit-msg"
  write_hook ${hook_path} "pre-push"
  write_hook ${hook_path} "pre-rebase"
  write_hook ${hook_path} "pre-receive"
  write_hook ${hook_path} "update"
}

function next_steps() {
  dialog::say "Steps included in this script:"
  cat $0 | grep '\[STEP' | grep -v "cat" | sed -r 's/[a-z_]* "(.*)"$/\t - \1/'
}

function summary() {
  dialog::say "Current Git global configuration: \n\
***
$(git config --global -l) \n\
***
If you want to edit the configuration, please run: \n\
\t ${new_editor} ~/.gitconfig \n\

If you want to edit the .gitignore_global file, please run: \n\
\t ${new_editor} ~/.gitignore_global \n\
(in case you want to tweak this file, you can find useful .gitignore configurations at: https://github.com/github/gitignore/) \n\

And if you need to reload your .bashrc file, please run: \n\
\t  source ~/.bashrc"
}

# Run main function
main
