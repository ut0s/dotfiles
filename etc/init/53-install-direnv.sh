#!/bin/bash
# @date Time-stamp: <2019-09-10 21:04:58 tagashira>
# @file 52-install-graphviz.sh
# @brief

set -e

mkdir -p $HOME/setup
cd $HOME/setup/

file="direnv-2.20.0.tar.gz"
url="https://github.com/direnv/direnv/archive/v2.20.0.tar.gz"

if [ -e $file ]; then
  echo "$file found."
else
  echo "$file NOT found."
  wget -O $file $url
  tar xf $file
fi

cd ${file%.tar.gz}

make -j$(nproc) &&\
make install DESTDIR=~/usr
