#!/bin/bash

source "src/lib/dialog.sh"

dialog::say "Installing git-toolset.sh script into ~/bin/ folder"

if [ ! -d ~/bin/ ]; then
  mkdir -p ~/bin;
fi

ln -sf $(pwd)/git-toolset.sh ~/bin/git-toolset

dialog::say "DONE, there is a reference of git-toolset in the ~/bin folder\n
If you want to add this to PATH, please execute:
  export PATH=\"~/bin:\$PATH\"
With it, you can call these tools directly using 'git-toolset'."
