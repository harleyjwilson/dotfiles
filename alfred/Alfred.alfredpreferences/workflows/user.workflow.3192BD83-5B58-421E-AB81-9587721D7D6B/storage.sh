#!/bin/zsh
source "${HOME}/.zshrc"

function getsize
{
	#If the directory does not exist, create it
	if ! [ -d "$1" ]
	then
		mkdir -p "$1"
	fi
	du -sh "$1" | cut -f1 | xargs
}

function displaysize
{
	echo -n "$1: "
	echo -n $(getsize "$2")
	echo $3
	
}


echo "<html><body>"

echo "<h1>Drafts Storage Utilisation Report</h1>"

echo "<h2>iCloud Database</h2>"
echo "<ul>"
displaysize "	<li>Drafts Database" "$HOME/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts" "</li>"
echo "</ul>"

echo "<h2>iCloud Drive</h2>"
echo "<ul>"
displaysize "	<li>Drafts iCloud Drive" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/" "</li>"
echo "	<ul>"
displaysize "		<li>Backups" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Backups" "</li>"
echo "		<ul>"
displaysize "			<li>Action Groups" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Backups/Action Groups" "</li>"
displaysize "			<li>Drafts" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Backups/Drafts" "</li>"
echo "		</ul>"
displaysize "		<li>Inbox" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Inbox" "</li>"
displaysize "		<li>Library" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library" "</li>"
echo "		<ul>"
displaysize "			<li>Themes" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library/Themes" "</li>"
displaysize "			<li>Previews" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library/Previews" "</li>"
displaysize "			<li>Scripts" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library/Scripts" "</li>"
displaysize "			<li>Syntaxes" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library/Syntaxes" "</li>"
displaysize "			<li>Templates" "$HOME/Library/Mobile Documents/iCloud~com~agiletortoise~Drafts5/Documents/Library/Templates" "</li>"
echo "		</ul>"
echo "	</ul>"
echo "</ul>"

echo "<h2>Local Storage</h2>"
echo "<ul>"
displaysize "	<li>Drafts Local" "$HOME/Library/Containers/com.agiletortoise.Drafts-OSX/Data/Documents" "</li>"
echo "</ul>"

echo
echo "<hr><p>Last Generated: $(date) by &copy; Doctor Drafts.</p><hr>"
