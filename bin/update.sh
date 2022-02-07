#!/bin/bash

# Don't forget to make the file executable `chmod a+x update.sh`

echo "Running \`brew update\`"
brew update
echo "Running \`brew outdated\`"
brew outdated
echo "Running \`mas outdated\`"
mas outdated
echo "Running \`softwareupdate -l\`"
softwareupdate -l
