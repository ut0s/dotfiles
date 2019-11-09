#!/bin/bash

DOT="$HOME/dotfiles/"

cd
mkdir -p tmp setup var/log etc usr bin 

cd "$DOT/etc/init"
for f in ??-*.sh
do
    # [[ "$f" == "" ]] && continue
    echo "$f"
    eval "$DOT/etc/init/$f"
done

