#!/bin/bash

function setup() {
  mkdir -p "$HOME/setup"
}

function install_fonts() {
  if [ ! -d "$HOME"/setup/fonts ]; then
    cd "$HOME"/setup &&
      git clone https://github.com/powerline/fonts.git --depth 1 &&
      cd fonts &&
      ./install.sh
  fi
}

setup
install_fonts
