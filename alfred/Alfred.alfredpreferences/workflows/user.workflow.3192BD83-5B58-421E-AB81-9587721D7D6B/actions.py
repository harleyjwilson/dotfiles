#!/usr/bin/env python3

import sqlite3
import sys
import json
from contextlib import closing
from os.path import expanduser

def searchAction():
	strPathDB = expanduser("~") + "/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts/DraftStore.sqlite"
	
    # Retrieve action group name and actions where the action group is enabled
	with closing(sqlite3.connect(strPathDB)) as connection:
		with closing(connection.cursor()) as cursor:
			rows = cursor.execute("select ZNAME, ZACTIONDATA from main.ZMANAGEDACTIONGROUP where ZHIDDEN = 0;".format()).fetchall()
			return rows

# Get all action groups and the JSON that defines the actions
allActionGroups = searchAction()

# Initialise an array to build out Alfred list item JSON into
arrItems = []

# Process each action group
for actionGroup in allActionGroups:
    # The first element of the array from the database query is the name of the action group
    actionGroupName = actionGroup[0]

    # The secnd element of the array from the database query is the JSON that defines the actions
    jsonActionGroup = json.loads(actionGroup[1])

    # Process every action in the action group
    for action in jsonActionGroup:
        # Initialise an output object
        objItem = {}
        
        # Ignore any separators
        bBuild = True
        if 'backingIsSeparator' in action:
            if action['backingIsSeparator']:
                bBuild = False

        # For each actionable action, add a new item to the output
        if bBuild:
            objItem['title'] = action['name']
            objItem['subtitle'] = actionGroupName
            objItem['arg'] = action['name']
            arrItems.append(objItem)

# Output the JSON for Alfred
objOutput = { "items" : arrItems }
sys.stdout.write(json.dumps(objOutput))
