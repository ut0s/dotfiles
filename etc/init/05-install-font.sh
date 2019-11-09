#!/bin/bash

pacman -S --noconfirm mingw64-w64-x86_64-fontconfig 

if [ -d $HOME/setup ]; then
    cd $HOME/setup/
else
    mkdir $HOME/setup
    cd $HOME/setup/
fi

git clone https://github.com/powerline/fonts.git --depth 1
cd fonts
./install.sh
