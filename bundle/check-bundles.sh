#!/bin/bash

for dir in *; do
  if [ -d $dir/.git ]; then
    echo "- Found git repo in $dir: Checking..."
    cd $dir
    git fetch && git log HEAD..origin
    echo "- Do you want to do a 'git pull'?"
    read choice
    if [ "$choice" = "y" ]; then
      git pull
    fi
    cd ..
  else
    echo "- No repo in $dir"
  fi
done
