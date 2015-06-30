#!/bin/bash

set -e # exit on error

if [ $TRAVIS_PULL_REQUEST != "false" ] ; then
  echo "Skipping deploy for pull request $TRAVIS_PULL_REQUEST"
  exit 1
fi

if [ $TRAVIS_BRANCH != "master" ] ; then
  echo "Skipping deploy from branch $TRAVIS_BRANCH"
  exit 1
fi

echo "Deploying..."
git remote add origin "https://$GH_TOKEN@github.com/hurrymaplelad/hmlad.com.git"
gulp deploy
