#!/bin/bash
#
# 動作確認用スクリプト
#
# 出来ればUnitTestとして記述する
# そこまでしなくても、この中で動作確認のための試し書きをして実行する
#

source ./main.sh

function test_fuga {
  fuga log_file.txt
  cat log_file.txt
}

function test_args {
  parse_args -o "output" input
  echo $INPUT_FILE
  echo $OUTPUT_FILE
}

function test_main {
  main item1 item2 0
}

#test_fuga
test_args
#test_main
