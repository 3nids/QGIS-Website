# to be able to run the full image (including pulling from transifex)
# you need a valid .transifexrc file with your credentials in your home dir
# this one is temporarily copied to the project dir
# and removed after build
# maybe better to create a qgisdocker transifex user?

cp /home/rduivenvoorde/.transifexrc .
pwd=$(pwd)
docker run -v $pwd:/site -w="/site" qgis/sphinx:1.0 make $@
rm -rf .transifexrc
