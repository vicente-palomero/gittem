#!/bin/bash

echo "Installing git-toolset.sh script into ~/bin/ folder"

ln -sf $(pwd)/git-toolset.sh ~/bin/git-toolset

echo "DONE, now you can call these tools directly using 'git-toolset'."
