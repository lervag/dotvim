#!/usr/bin/env bash

target="$HOME/.local/plugged/vim-plug"
destination="$(dirname "$0")/autoload/plug.vim"


echo -n "Fetching vim-plug ... "
if [ -d "$target" ]; then
  echo "already fetched."
else
  echo "done!"
  mkdir -p "$(dirname "$target")"
  git clone --depth 1 https://github.com/junegunn/vim-plug.git "$target"
fi

echo -n "Installing vim-plug ... "
if [ -e "$destination" ]; then
  echo "already installed."
else
  echo "done!"
  mkdir -p "$(dirname "$destination")"
  ln -s "$target/plug.vim" "$destination"
fi
