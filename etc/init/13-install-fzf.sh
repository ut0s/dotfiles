#!/bin/bash
# @file 13-install-fzy.sh
# @brief

if [ $(which fzy) ]; then
  echo "Alreadey exist fzy"
  exit 0
else
  pacman -S --noconfirm fzy
fi
