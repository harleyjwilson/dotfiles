#!/bin/zsh

source "${HOME}/.zshrc"

# This function is run if there is an error
function pythonError
{
	# Display error notification
	osascript -e 'display notification "The function you selected requires Python 3 which could not be found. \n\nOpening diagnostics report..." with title "ERROR: Python 3 Not Found"'
	
	# Play a sound
	afplay "/System/Library/Sounds/Basso.aiff"
	
	# Open the diagnostic report
	osascript -e "tell application id \"com.runningwithcrayons.Alfred\" to run trigger \"drdiag\" in workflow \"com.thoughtasylum.doctordrafts\" with argument \"test\""
}

# Check the default version of Python.
PYVER_DEFAULT=$(python -V 2>&1 | cut -c8-9)
# If the user has set it via PyEnv or through their path, we should get a "3." version back
# and we can run it just by calling the script with "python"
if [ "$PYVER_DEFAULT" = "3." ]
then
	python $1 ${@:2}
else
	# The default is not v3 (probably a v2), so we need to make an explicit fallback v3 check
	# If there is a Python 3 specified, then use that
	PYVER_3=$(python3 -V 2>&1 | cut -c8-9)
	
	if [ "$PYVER_3" = "3." ]
	then
		python3 $1 ${@:2}
	else
		# Either Python 3 is not there or the config is wrong.
		# Pop up a notification and open the diagnostics report.
		pythonError 
	fi
fi
