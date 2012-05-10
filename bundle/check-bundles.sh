#!/bin/bash

for dir in */.git; do

  repo=${dir::-5}
  cd $repo

  git fetch && git log HEAD..origin
  echo "- In $repo: Do you want to do a 'git pull'?"
  read choice
  [ "$choice" = "y" ] && git pull

  cd ..
done
