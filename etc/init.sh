#!/bin/bash

set -eux

function install_deps() {
  if [ "$(which apt)" ]; then
    echo 'apt command found'
    sudo apt install -y git make nano
  elif [ "$(which dnf)" ]; then
    echo 'dnf command found'
    sudo dnf install -y git make nano
  elif [ "$(which pacman)" ]; then
    sudo pacman -Sy --noconfirm git make nano
  elif [ "$(which brew)" ]; then
    if ! type brew >/dev/null 2>&1; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git nano
  else
    echo 'package manager not found'
    exit 1
  fi
}

function clone_dotfiles() {
  if [ ! -d dotfiles ]; then
    git clone https://github.com/ut0s/dotfiles.git --depth 1
  fi
}

install_deps
clone_dotfiles
cd "$HOME"/dotfiles
make install
make deploy
brew bundle

# fisher
fish -C "fisher install < $HOME/dotfiles/misc/fisher.list"
