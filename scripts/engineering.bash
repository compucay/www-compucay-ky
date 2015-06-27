#!/bin/bash
# script name : edit.bash
# script args : $1 -- file to be edited [ALL for working+sub directories]
#       $2 -- comments for git
#       $3 -- remove interactivity if parameter equals "noprompting"
#
# The script ensures that edits are pushed to the engineering
# on Heroku. 
#
# git remote rm origin
# git remote add origin https://github.com/compucay/engineering-compucay-ky.git

git init
if [ $1 == "ALL" ] ; then
	git add --all .
else
	git add $1
fi
git commit -m "$2"
cat ~/.netrc | grep heroku || heroku login && heroku keys:add ~/.ssh/id_rsa.pub
heroku apps:destroy engineering-compucay-ky --confirm engineering-compucay-ky
heroku apps:create engineering-compucay-ky
heroku domains:add engineering.compucay.ky --app engineering-compucay-ky
heroku git:remote -a engineering-compucay-ky
git push heroku master
