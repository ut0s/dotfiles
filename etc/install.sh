#!/bin/bash

set -ux

DOTFILES="$HOME"/dotfiles

function install() {
  if [ "$(uname)" = "Linux" ]; then
    "$DOTFILES"/etc/script/00-install-brew.sh
  fi

  "$DOTFILES"/etc/script/05-install-font.sh
  brew bundle --file="$DOTFILES"/etc/Brewfile
}

install
