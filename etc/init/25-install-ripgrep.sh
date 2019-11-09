#!/bin/bash

mkdir -p $HOME/setup
cd $HOME/setup/

which curl || pacman -S --noconfirm curl

cargo install ripgrep &&\
echo "Done: Install ripgrep"
