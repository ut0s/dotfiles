#!/bin/bash
# @date Time-stamp: <2020-05-31 03:40:58 tagashira>
# @file lockblur.sh
# @brief
# @ref https://gist.github.com/csivanich/10914698#file-lock-sh

# i3lock blurred screen inspired by /u/patopop007 and the blog post
# http://plankenau.com/blog/post-10/gaussianlock

# Dependencies:
# imagemagick
# i3lock
# scrot (optional but default)

mkdir -p $HOME/tmp
IMAGE="$HOME/tmp/i3lock.png"
SCREENSHOT="scrot $IMAGE" # 0.46s

# Alternate screenshot method with imagemagick. NOTE: it is much slower
# SCREENSHOT="import -window root $IMAGE" # 1.35s

# Here are some imagemagick blur types
# Uncomment one to use, if you have multiple, the last one will be used

# All options are here: http://www.imagemagick.org/Usage/blur/#blur_args
# BLURTYPE="0x5" # 7.52s
# BLURTYPE="0x2" # 4.39s
# BLURTYPE="5x2" # 3.80s
# BLURTYPE="2x8" # 2.90s
# BLURTYPE="2x3" # 2.92s
BLURTYPE="5x5"

# Get the screenshot, add the blur and lock the screen with it
$SCREENSHOT
convert $IMAGE -blur $BLURTYPE $IMAGE
i3lock -i $IMAGE
rm $IMAGE
