#!/bin/bash
set -u

readonly DOT_FILES=(
  Brewfile
  .Xresources
  .Xresources.d
  .aspell.conf
  .aspell.conf
  .aspell.en.pws
  .bash_alias
  .bash_alias_mac
  .bash_myconfig
  .bashrc
  .clang-format
  .emacs.d
  .gitconfig
  .gitignore_global
  .nanorc
  .profile
  .pythonstartup
  .tigrc
  .urxvt
  .codex
  .serena
  .gemini
  .copilot
)

readonly DOT_CONFIG_FILES=(
  fish
  i3
  ranger
  terminator
  tmux
  alacritty
  zed
  gitu
  nnn
  mpv
  yazi
)

function deploy() {
  for file in "${DOT_FILES[@]}"; do
    if [ -a "$HOME"/"$file".dot ]; then
      rm -v "$HOME"/"$file".dot
      ln -vs "$HOME"/dotfiles/"$file" "$HOME"/"$file"
    else
      unlink "$HOME"/"$file"
      ln -vs "$HOME"/dotfiles/"$file" "$HOME"/"$file"
    fi
  done

  for file in "${DOT_CONFIG_FILES[@]}"; do
    if [ -a "$HOME"/.config/"$file".dot ]; then
      rm -v "$HOME"/.config/"$file".dot
      ln -vs "$HOME"/dotfiles/.config/"$file" "$HOME"/.config/"$file"
    else
      unlink "$HOME"/.config/"$file"
      ln -vs "$HOME"/dotfiles/.config/"$file" "$HOME"/.config/"$file"
    fi
  done
}

mkdir -p "$HOME"/.config
deploy
