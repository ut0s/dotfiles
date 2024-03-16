#!/bin/bash

set -u

DOTFILES="$HOME"/dotfiles

function install_deps() {
  which shellscript || bash "$HOME"/dotfiles/etc/script/03-shellcheck.sh
  which shfmt || bash "$HOME"/dotfiles/etc/script/03-shfmt.sh
}

function linter() {
  files=(
    "$DOTFILES"/etc/*.sh
    "$DOTFILES"/etc/script/*.sh
  )
  for file in "${files[@]}"; do
    shfmt -w "${file}"
    shellcheck "${file}"
  done
}

install_deps
linter
