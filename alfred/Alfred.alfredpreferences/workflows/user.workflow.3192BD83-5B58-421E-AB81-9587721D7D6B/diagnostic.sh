#!/usr/bin/env zsh
source "${HOME}/.zshrc"

echo "<html><body>"


echo "<style>"
echo "pre {"
echo "font-family: Consolas, Courier, monospace;"
echo "white-space: pre-wrap;"
echo "tab-size: 4;"
echo "background: #D3D3D3;"
echo "color: black;"
echo "padding:20px;"
echo "border-radius: 5px;"
echo "}"
echo "</style>"

# Check for Alfred being installed - it really should be if they are running this script
# But for completeness and in case I have to ask someone to run it standalone.
echo "<h1>Alfred</h1>"
echo "<p>The Doctor Drafts workflow for Alfred is for controlling the Drafts app. Alfred is a foundational pre-requisite, and expects Alfred version 4 to be available.</p>"
if [ -d "/Applications/Alfred 4.app" ]
then
	echo "<p style=\"color:green\">&check; Alfred 4 is installed.</p>"
else
	echo "<p style=\"color:red\">&cross; We cannot find an installation of the Alfred 4 app.</p>"
	echo "<p>Please install <a href=\"https://www.alfredapp.com\">the Alfred app from Alfred App's website</a>.</p>"
fi

echo "<p>Doctor Drafts is a custom Alfred workflow. To run it, you <strong>must</strong> have a valid <a href=\"https://www.alfredapp.com/powerpack/\">Alfred Power Pack license</a> in place.</p>"

cd "$HOME/Library/Application Support/Alfred"
alfredLicenseFile=$(ls license.*.plist) 2>/dev/null
if [ "$alfredLicenseFile" = "" ]
then
	echo "<p style=\"color:red\">&cross; We cannot find the Alfred Power Pack license information.</p>"
else
	echo "<p style=\"color:green\">&check; Alfred 4 Power Pack information identified.</p>"
	licensePath=$(ls license.*.plist)	
	licenseEmail=$(defaults read "$HOME/Library/Application Support/Alfred/$licensePath" email)
	licenseCode=$(defaults read "$HOME/Library/Application Support/Alfred/$licensePath" code)
	
	echo "<details>"
	echo "<summary>Alfred Power Pack Information</summary>"
	echo "<div><ul>"
	echo "	<li>License E-mail: $licenseEmail</li>"
	echo "	<li>License Code: $licenseCode</li>"
	echo "</ul></div>"
	echo "</details>"
fi

echo "<h2>Doctor Drafts Workflow</h2>"
echo "<p>"
echo -n "<strong>Installed Version:</strong> "
echo $alfred_workflow_version
echo "<br>"
echo -n "<strong>Latest Available Version:</strong> "
curl -s https://doctordrafts.thoughtasylum.com/latestversion.txt
echo "</p>"

# Check for Drafts being installed
echo "<h1>Drafts</h1>"
echo "<p>The Doctor Drafts workflow for Alfred is for controlling the Drafts app. Drafts is a foundational pre-requisite. Some Drafts functionality, such as workspaces, are only available to Drafts Pro subscribers. If you wish to make use of such functionality in Doctor Drafts, you must ensure that you have an active <a href=\"https://docs.getdrafts.com/draftspro\">Drafts Pro Subscription</a>.</p>"
if [ -d "/Applications/Drafts.app" ]
then
	echo "<p style=\"color:green\">&check; Drafts is installed.</p>"
	
	#Initialise Drafts Information variables
	DV=$(defaults read "/Applications/Drafts.app/Contents/Info" CFBundleVersion)
	PN=$(sw_vers -productName)
	PV=$(sw_vers -productVersion)
	BV=$(sw_vers -buildVersion)
	cp "$HOME/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts/Library/Preferences/GTFQ98J4YG.com.agiletortoise.Drafts.plist" "$HOME/doctorDrafts-Drafts.plist"
	SID=$(defaults read "$HOME/doctorDrafts-Drafts" com.agiletortoise.SubscriptionManager.Identifier)
	EXP=$(defaults read "$HOME/doctorDrafts-Drafts" com.agiletortoise.SubscriptionManager.ExpirationDate)
	EXPDTLEN=$(echo -n $EXP | wc -m)
	if [[ EXPDTLEN != 0 ]]
	then
		BETA=" *"
	else
		BETA=""
	fi
	rm "$HOME/doctorDrafts-Drafts.plist"
	
	echo "<ul>"
	echo "	<li>Drafts Version: $DV$BETA</li>"
	echo "	<li>OS Version: $PN, $PV ($BV)</li>"
	echo "</ul>"

	echo "<details>"
	echo "<summary>Drafts Subscription Information</summary>"
	echo "<div><ul>"
	echo "	<li>Subscription ID: $SID</li>"
	echo "	<li>Subscribed Until: $EXP</li>"
	echo "</ul></div>"
	echo "</details>"


	
else
	echo "<p style=\"color:red\">&cross; We cannot find an installation of the Drafts app.</p>"
	echo "<p>Please install <a href=\"https://apps.apple.com/gb/app/drafts/id1435957248?mt=12\">the Drafts app from the Mac app store</a>.</p>"
fi


# Gather Python information for the Alfred session
# Python2 version seems to go to stderr, stdout
p2=$(python2 --version 2>&1)
p3=$(python3 --version)
pd=$(python --version)

# Output Python Information
echo "<h1>Python</h1>"
echo "<p>Doctor Drafts uses Python 3 for some of the more advanced interaction  features. While you can still use many fgeatures without it, we strongly recommend having Python 3 available in order to access the full power of Doctor Drafts.</p>"
echo "<p>To make use of Python 3, it must be installed and be found in your \$PATH environment variable, so that Doctor Drafts knows where to find it.</p>"
echo
echo "<p>We found the following Python versions available:</p>"
echo 
echo "<ul>"
echo "<li>Python 3: $p3</li>"
echo "<li>Python 2: $p2</li>"
echo "<li>Python (Default): $pd</li>"
echo "</ul>"
echo

# Check the length of the Python 3 version string
if [[ -n "$p3" ]]
then
	echo "<p style=\"color:green\">&check; Alfred can find a Python 3 installation.</p>"
else
	echo "<p style=\"color:red\">&cross; Alfred cannot find a Python 3 installation.</p>"
	echo "<p>Please read <a href=\"https://doctordrafts.thoughtasylum.com/basic/installation/\">how to install Python 3 for use with Doctor Drafts</a>.</p>"
fi

echo
echo "<h1>PATH Variable</h1>"
echo "<p>Your \$PATH variable paths are as follows:</p>"
echo
echo "<pre>"
# Substitute the path delimiters with newlines
echo -e ${PATH:gs/\:/\\n/}
echo "</pre>"


echo
echo "<h1>.zshenv Content</h1>"
echo "<p>Your ZSH Environment file content is as follows:</p>"
echo
echo "<pre>"
cat "$HOME/.zshenv"
echo "</pre>"

echo
echo "<h1>.zprofile Content</h1>"
echo "<p>Your ZSH Profile file content is as follows:</p>"
echo
echo "<pre>"
cat "$HOME/.zprofile"
echo "</pre>"

echo
echo "<h1>.zshrc Content</h1>"
echo "<p>Your ZSH Run Command file content is as follows:</p>"
echo
echo "<pre>"
cat "$HOME/.zshrc"
echo "</pre>"

echo
echo "<h1>.zlogin Content</h1>"
echo "<p>Your ZSH login file content is as follows:</p>"
echo
echo "<pre>"
cat "$HOME/.zlogin"
echo "</pre>"


echo
echo "<hr><p>Last Generated: $(date) by &copy; Doctor Drafts.</p><hr>"
echo "</body></html>"