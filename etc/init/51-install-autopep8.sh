#!/bin/bash
# @file 51-install-autopep8.sh
# @brief


mkdir -p $HOME/dotfiles/cloning_git
cd $HOME/dotfiles/cloning_git

if [ $(which autopep8) ]; then
  echo "Alreadey exist autopep8"
  exit
else
  git clone --depth 1 https://github.com/hhatto/autopep8.git && echo "Clonig autopep8 have done"
  cd autopep8
  echo "Change autopep8 default indent length"
  before="DEFAULT_INDENT_SIZE = 4"
  after="DEFAULT_INDENT_SIZE = 2"
  sed -i "s#$before#$after#g" autopep8.py

  echo "Install autopep8"
  python3 setup.py install --user --prefix=
fi
