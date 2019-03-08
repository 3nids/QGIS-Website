
# script to be run on server serving the static content of the website
# doc root in /ar/www/qgis_new_web/QGIS-Website/live/html

mkdir -p /var/www/qgisdata/QGIS-Website/live/html/feeds
# cd to feed output dir
cd /var/www/qgisdata/QGIS-Website/live/html/feeds

# get latest qgis flickrmaps
mv qgisflickrmaps.atom qgisflickrmaps.atom.0
curl "https://api.flickr.com/services/feeds/groups_pool.gne?id=2244553@N22&lang=en-us&format=atom" -o qgisflickrmaps.atom

# get latest qgis flickrscreenshots
mv qgisflickrscreenshots.atom qgisflickrscreenshots.atom.0
curl "https://api.flickr.com/services/feeds/groups_pool.gne?id=2327386@N22&lang=en-us&format=atom" -o qgisflickrscreenshots.atom

# get latest planet feed
mv qgisplanet.atom qgisplanet.atom.0
curl -o qgisplanet.atom "http://planet.qgis.org/planet/feed/atom/"

# get qugsnews (from github)
mv qugsnews.atom qugsnews.atom.0
curl https://raw.githubusercontent.com/qgis/QGIS-Website/master/source/feeds/qugsnews.atom -o qugsnews.atom

# get sponsors (from changelog.qgis.org/projecta)
#mv qgissponsors.atom qgissponsors.atom.0
#curl http://changelog.qgis.org/en/qgis/sponsors/atom/ -o qgissponsors.atom
# and list of past sponsors too
#mv qgispastsponsors.atom qgispastsponsors.atom.0
#curl http://changelog.qgis.org/en/qgis/past-sponsors/atom/ -o qgispastsponsors.atom

# get sponsors (from changelog.qgis.org/projecta)
mv qgissponsors.json qgissponsors.json.0
curl http://changelog.qgis.org/en/qgis/sponsors/json/ -o qgissponsors.json
# and list of past sponsors too
mv qgispastsponsors.json qgispastsponsors.json.0
curl http://changelog.qgis.org/en/qgis/past-sponsors/json/ -o qgispastsponsors.json
