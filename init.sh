#!/usr/bin/env bash

echo -n "Fetching vim-plug ... "
if [ -d ~/.vim/bundle/vim-plug ]; then
  echo "already fetched."
else
  echo "done!"
  git clone --depth 1 https://github.com/junegunn/vim-plug.git ~/.vim/bundle/vim-plug
fi

echo -n "Installing vim-plug ... "
if [ -e ~/.vim/autoload/plug.vim ]; then
  echo "already installed."
else
  echo "done!"
  mkdir -p ~/.vim/autoload
  ln -s ../bundle/vim-plug/plug.vim ~/.vim/autoload/plug.vim
fi
