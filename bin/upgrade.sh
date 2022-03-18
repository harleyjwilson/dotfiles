#!/bin/bash

# Don't forget to make the file executable `chmod a+x update.sh`

echo "Running \`brew upgrade\`"
brew upgrade
echo "Running \`omz update\`"
omz update
echo "Running \`mas upgrade\`"
mas upgrade
echo "Running \`softwareupdate -i -a\`"
softwareupdate -i -a
