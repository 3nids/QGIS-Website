#!/usr/bin/python

exec(open("source/schedule.py").read())

f = open("output/html/version.txt", "w")

f.write( """#QGIS Version %(versionint)d|Visit http://download.qgis.org to get your copy of version %(version)s|<html><body>
<ul>
<li>The current released version of QGIS is %(version)s.
<li>We are working on %(devversion)s-Master. It will go into feature freeze on %(freezedate)s and be released as %(nextversion)s on %(nextreleasedate)s.
<li>Details on changes can be found by examining the Activity in Redmine at <a href="https://issues.qgis.org/projects/qgis">https://issues.qgis.org/projects/qgis</a>.
</body>
</html>
""" % {
	"versionint": int("%d%02d%02d" % tuple( map(int, release.split(".")))),
	"version": release,
	"devversion": devversion,
	"freezedate": nextfreezedate if nextfreezedate is not None else "a not yet determined date",
	"nextreleasedate": nextreleasedate if nextreleasedate is not None else "a not yet determined date",
	"nextversion": nextversion,
} )

f.close()
