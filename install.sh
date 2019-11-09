#!/bin/bash

DOT="$HOME/dotfiles/"

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".config" ]] && continue
    echo "$DOT$f"
    rsync -a "$DOT$f" ~
done

cd .config
for f in *
do
    echo "$DOT/.config/$f"
    rsync -a "$DOT/.config/$f" ~/.config
done
