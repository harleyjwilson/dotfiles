#!/usr/bin/env python3

import sqlite3
import sys
import unicodedata as ud
from contextlib import closing
from os.path import expanduser

def searchDraft(strSearch):
	strPathDB = expanduser("~") + "/Library/Group Containers/GTFQ98J4YG.com.agiletortoise.Drafts/DraftStore.sqlite"
	
	with closing(sqlite3.connect(strPathDB)) as connection:
		with closing(connection.cursor()) as cursor:
			rows = cursor.execute("select ZUUID, ZCONTENT, ZCREATED_AT, ZCHANGED_AT from main.ZMANAGEDDRAFT where ZCONTENT like '{}%' and ZFOLDER != 10000 order by ZCHANGED_AT desc;".format(strSearch)).fetchall()
			return rows


# Combine the arguments we want
strArg = ' '.join(sys.argv[1:])
# Normalise any decomposed UTF-8 text from Alfred to composed UTF-8 test to use with SQLite
strArg = ud.normalize('NFC',strArg)

draftMatch = searchDraft(strArg)
if len(draftMatch) == 0:
	sys.stdout.write('')
else:
	sys.stdout.write(draftMatch[0][0])