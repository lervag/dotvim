#!/bin/bash

for dir in *; do
  if [ -d $dir/.git ]; then
    echo "- Found git repo in $dir: Checking..."
    cd $dir
    git fetch && git log HEAD..origin
    cd ..
  else
    echo "- No repo in $dir"
  fi
  rm -r **/.git/objects
done
