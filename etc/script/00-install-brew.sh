#!/bin/bash

function install_deps() {
  echo "Installing dependencies"
  if [ "$(which apt)" ]; then
    echo 'apt command found'
    sudo apt install -y build-essential procps curl file git
  elif [ "$(which dnf)" ]; then
    echo 'dnf command found'
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y procps-ng curl file git
  elif [ "$(which pacman)" ]; then
    sudo pacman -Sy --noconfirm base-devel procps-ng curl file git
  else
    echo 'package manager not found'
    exit 1
  fi
}

function install_brew() {
  if [ "$(which brew)" ]; then
    echo "Homebrew is installed"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_deps
install_brew

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc
