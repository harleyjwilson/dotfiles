#!/usr/bin/env python3

import sqlite3
import sys
import json
import unicodedata as ud
from contextlib import closing
from os.path import expanduser

def searchWorkspace(strSearch):
	strPathDB = expanduser("~") + "/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts/DraftStore.sqlite"
	
	with closing(sqlite3.connect(strPathDB)) as connection:
		with closing(connection.cursor()) as cursor:
			rows = cursor.execute("select ZVALUE, Z_OPT, ZHIDDEN, ZKEY from main.ZMANAGEDSTORAGE where ZTYPE = \"workspace\" and ZHIDDEN = 0 and ZKEY NOT LIKE \"%|##|%\" order by ZSORT_INDEX;".format(strSearch)).fetchall()
			return rows


# Combine the arguments we want
strArg = ' '.join(sys.argv[1:])
# Normalise any decomposed UTF-8 text from Alfred to composed UTF-8 test to use with SQLite
strArg = ud.normalize('NFC',strArg)

draftMatch = searchWorkspace(strArg)
arrItems = []
for x in draftMatch:
	jsonData = json.loads(x[0])
	objItem = {}
	objItem['title'] = jsonData['name']
	#objItem['subtitle'] = ""
	objItem['arg'] = jsonData['name']
	arrItems.append(objItem)
	#sys.stdout.write(jsonData['name'] + "\n")

objOutput = { "items" : arrItems }
sys.stdout.write(json.dumps(objOutput))