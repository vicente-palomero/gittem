# Gittem: Git Interface for Tips and Tooling Environment Manager

Gittem is a set of scripts with the purpose of helping users in their daily work with Git. For that, it offers tips to show how to do common and not so common actions, a script for the main configuration of Git, and a hook manager.

Scripts to simplify git usage.

## tl;dr: Quick installation and setup in your repo:

- Install `gittem` running: `./install.sh`
- Add `export PATH="~/bin:$PATH"` to your `.bashrc` file
- Set up gittem running: `gittem -g`
- Add `gittem` to a git project running: `gittem -i`

## Detailed installation

Install method generates a symlink at of `gittem.sh` file at `~/bin/` folder. This `gittem` script acts a simple interface for the different tools included.

```bash
./install.sh
```

## Usage

The script `gittem` enables the usage of this toolset everywhere in your code.

## Global setup
This script helps to set up an initial global configuration for git.
It asks for the user name, the email, the default editor (`nano` recommended), if a `.gitignore_global` file should modify the prompt for adding a reference to the current branch.

You can run this script by executing:
```bash
gittem -g
```

## Installation of hook toolset

This hook toolset lets you adding and removing hooks easily:

```bash
gittem -i
```

After running it, a folder `gittem` is created inside yout `.git` folder. There is a file called `config` in this new folder, initially with this content:

```bash
[commit-msg]
    add_timestamp=hooks/commitmsg/add_timestamp
```

This `add_timestamp` hook will be executed each time you do a commit, and it adds a timestamp in the beginning of the commit message. If you want to add or remove other hooks, you have to edit this file following that format.

In case you want to deactivate a hook, you can simply comment the line with a # in the beginning.

## Hooks
`gittem` installs 3 different hooks:
-. `tips` will give you some tips and useful tricks for git.
-. `cleanup` will remove already merged branches on master and any branch starting by `dev`.
-. `hook`, which is used for running the hook related with a git step. You also can run it separately.

## Tips and ideas

* You can avoid a hook with the `--no-verify` or `-n` parameter.
* You can print the working directory running `pwd`, which is useful for scripts like `hooks_installer.sh`.
* E.g.: `my_repo % path_to_gittem/hooks_installer.sh -r $(pwd)`
