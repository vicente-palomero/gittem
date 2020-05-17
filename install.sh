#!/bin/bash

echo "Installing git-toolset.sh script into ~/bin/ folder"

if [ ! -d ~/bin/ ]; then
    mkdir -p ~/bin;
fi

ln -sf $(pwd)/git-toolset.sh ~/bin/git-toolset

echo "DONE, there is a reference of git-toolset in the ~/bin folder"
echo ""
echo "If you want to add this to PATH, please execute:"
echo ""
echo '   export PATH="~/bin:$PATH"'
echo ""
echo "With it, you can call these tools directly using 'git-toolset'."
