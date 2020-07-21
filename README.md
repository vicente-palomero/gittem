# git-toolset
Scripts to simplify git usage.

## tl;dr: Quick installation and setup in your repo:

- Install `git-toolset` running: `./install.sh`
- Add `export PATH="~/bin:$PATH"` to your `.bashrc` file
- Set up git-toolset running: `git-toolset -g`
- Add `git-toolset` to a git project running: `git-toolset -i`

## Detailed installation

Install method generates a symlink at of `git-toolset.sh` file at `~/bin/` folder. This `git-toolset` script acts a simple interface for the different tools included.

```bash
./install.sh
```

## Usage

The script `git-toolset` enables the usage of this toolset everywhere in your code.

## Global setup
This script helps to set up an initial global configuration for git.
It asks for the user name, the email, the default editor (`nano` recommended), if a `.gitignore_global` file should modify the prompt for adding a reference to the current branch.

You can run this script by executing:
```bash
git-toolset -g
```

## Installation of hook toolset

This hook toolset lets you adding and removing hooks easily:

```bash
git-toolset -i
```

After running it, a folder `git-toolset` is created inside yout `.git` folder. There is a file called `config` in this new folder, initially with this content:

```bash
[commit-msg]
    add_timestamp=hooks/commitmsg/add_timestamp
```

This `add_timestamp` hook will be executed each time you do a commit, and it adds a timestamp in the beginning of the commit message. If you want to add or remove other hooks, you have to edit this file following that format.

In case you want to deactivate a hook, you can simply comment the line with a # in the beginning.

## Hooks
`git-toolset` installs 3 different hooks:
-. `tips` will give you some tips and useful tricks for git.
-. `cleanup` will remove already merged branches on master and any branch starting by `dev`.
-. `hook`, which is used for running the hook related with a git step. You also can run it separately.

## Tips and ideas

* You can avoid a hook with the `--no-verify` or `-n` parameter.
* You can print the working directory running `pwd`, which is useful for scripts like `hooks_installer.sh`.
  * E.g.: `my_repo % path_to_git_toolset/hooks_installer.sh -r $(pwd)`
