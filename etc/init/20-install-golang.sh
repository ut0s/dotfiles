#!/bin/bash

mkdir -p $HOME/setup
cd $HOME/setup/

file=empty

if [ $(uname -m |grep x86) ] ; then
    echo "x86 architecture"
    file="go1.10.1.linux-amd64.tar.gz"

    if [ -e $file ]; then
        echo "$file found."
    else
        echo "$file NOT found."
        wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz
    fi
fi
echo "Done: Download golang"

mkdir -p $HOME/usr/local
tar -C $HOME/usr/local -xvf $file &&\
echo "Done: Install golang"
