#!/usr/bin/bash

echo -n "Fetching vim-plug ... "
if [ -d bundle/vim-plug ]; then
  echo "already fetched."
else
  echo "done!"
  git clone https://github.com/junegunn/vim-plug.git bundle/vim-plug
fi

echo -n "Installing vim-plug ... "
if [ -e autoload/plug.vim ]; then
  echo "already installed."
else
  echo "done!"
  mkdir -p ~/.vim/autoload
  ln -s bundle/vim-plug/vim-plug.vim ~/.vim/autoload/vim-plug.vim
fi

