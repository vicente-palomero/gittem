#!/bin/bash
#
# Installation script for gittem

source "src/lib/dialog.sh"

dialog::say "Installing gittem.sh script into ~/bin/ folder"

if [ ! -d ~/bin/ ]; then
  mkdir -p ~/bin;
fi

ln -sf $(pwd)/gittem.sh ~/bin/gittem

dialog::say "DONE, there is a reference of gittem in the ~/bin folder\n
If you want to add this to PATH, please execute:
  export PATH=\"~/bin:\$PATH\"
With it, you can call these tools directly using 'gittem'."
