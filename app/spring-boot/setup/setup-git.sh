#!/bin/bash

# removing https:// substring from the git url
# because in "git remote add origin" command it's already available
URI=${GIT_URI:8}

# call url encoder to handle password special chars
#source setup/url_encoder.sh ${GIT_REPO_PWD}

# initialize the git repo & push into the git
cd app
git init
git config user.email "${GIT_REPO_EMAIL}"
git config user.name "${GIT_REPO_UNAME}"
git add .
git commit -m "first commit"
error=$(git remote add origin https://gitlab-ci-token:${GIT_REPO_TKN}@$URI 2>&1 1>/dev/null)
if [ $? -eq 0 ]; then
   echo "git uri ${GIT_URI} has been added as origin"
else
   echo "Failed to add git uri ${GIT_URI} as origin. \n Error: $error"
   return 100
fi
#git remote add origin https://${GIT_REPO_TKN}@$URI
#error=$(git push -u origin master 2>&1 1>/dev/null)
echo "executing git push to main"
echo "current workdir" $(pwd)
error=$(git push -u origin master 2>&1)
echo "exit code of git push to main is $?"
if [ $? -eq 0 ]; then
   echo "pushed code to ${GIT_URI} origin"
else
   echo "Failed to push code to ${GIT_URI} origin. \n Error: $error"
   return 100
fi