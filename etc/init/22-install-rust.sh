#!/bin/bash

mkdir -p $HOME/setup
cd $HOME/setup/

#install cargo
if [ $(which cargo) ] ;then
    echo 'cargo command found'
else
    echo 'install cargo'
    pacman -S mingw-w64-x86_64-rust
fi

