# git_toolset
Scripts to simplify git usage.

## Global_setup
This script helps to set up an initial global configuration for git.
It asks for the user name, the email, the default editor (`nano` recommended), and if a `.gitignore_global` file should be created.

You can run this script by executing:
```bash
./global_setup.sh
```

## hooks_installer

List of hook scripts to install:
* No hook defined yet

You can run this script by executing:
```bash
./hooks_installer.sh -r PATH_OF_REPO
```

The results of this installation are in the `.git/hooks/` folder of your repository.

## tips
Here you can find some tips and tips for git. Run it by:
```bash
./tips.sh
```

Or, if you installed it as an alias via `global_setup.sh`:
```
git tips
```

## Tips and ideas

* You can avoid a hook with the `--no-verify` or `-n` parameter.
* You can print the working directory running `pwd`, which is useful for scripts like `hooks_installer.sh`.
  * E.g.: `my_repo % path_to_git_toolset/hooks_installer.sh -r $(pwd)`
