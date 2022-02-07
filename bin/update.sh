#!/bin/bash

# Don't forget to make the file executable `chmod a+x update.sh`

brew upgrade
mas upgrade
softwareupdate -i -a
