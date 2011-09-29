#!/bin/bash

for dir in *; do
  if [ -d $dir/.git ]; then
    echo "- Found git repo in $dir: Updating..."
    cd $dir
    git pull
    cd ..
  else
    echo "- No repo in $dir"
  fi
done
