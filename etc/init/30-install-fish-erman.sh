#!/bin/bash

mkdir -p $HOME/setup
cd $HOME/setup/

pacman -S --noconfirm fish

# install fisher
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
