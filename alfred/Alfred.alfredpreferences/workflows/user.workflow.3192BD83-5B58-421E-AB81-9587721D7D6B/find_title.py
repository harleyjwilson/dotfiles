#!/usr/bin/env python3

import sqlite3
import sys
import time
import json
import unicodedata as ud
from contextlib import closing
from os.path import expanduser

def searchDraft(strSearch):
	strPathDB = expanduser("~") + "/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts/DraftStore.sqlite"
	
	with closing(sqlite3.connect(strPathDB)) as connection:
		with closing(connection.cursor()) as cursor:
			rows = cursor.execute("select ZUUID, ZCONTENT, ZCREATED_AT, ZCHANGED_AT from main.ZMANAGEDDRAFT where ZCONTENT like '{}%' and ZFOLDER != 10000;".format(strSearch)).fetchall()
			return rows


# Combine the arguments we want
strArg = ' '.join(sys.argv[1:])
# Normalise any decomposed UTF-8 text from Alfred to composed UTF-8 test to use with SQLite
strArg = ud.normalize('NFC',strArg)

intSQLLiteEpoch = 978307200
draftMatch = searchDraft(strArg)
arrItems = []
for x in draftMatch:
	objItem = {}
	objItem['title'] = x[1].partition('\n')[0]
	objItem['subtitle'] = "Modified: " + time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(x[3] + intSQLLiteEpoch)) + " | Created: " + time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(x[2] + intSQLLiteEpoch))
	objItem['arg'] = x[0]
	arrItems.append(objItem)

objOutput = { "items" : arrItems }
sys.stdout.write(json.dumps(objOutput))
		