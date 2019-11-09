#!/bin/bash
#
# スクリプトの内容の説明
#
# 説明の詳細文を記述します。
#
# https://www.m3tech.blog/entry/2018/08/21/bash-scripting#bash%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E8%AC%9B%E5%BA%A7

# bashのスイッチ
set -euC

# 外部スクリプトのsource
#source ./setting.inc

# グローバル定数
readonly DEBUG=false
readonly WORKDIR=/tmp/mydir

# グローバル変数
INPUT_FILE=
OUTPUT_FILE=
FLAG=0

#
# 引数parse処理
#

function usage() {
  # パラメータの詳細を必ず明記すること
  cat <<EOS >&2
Usage: $0 [-o OUTPUT_FILE] [-a] INPUT_FILE
  INPUT_FILE      入力ファイル
  -o OUTPUT_FILE  出力ファイル
  -a              オプション。〜〜を〜〜として動作します
EOS
  exit 1
}

# 引数のパース
function parse_args() {
  while getopts "o:a" OPT; do
    case $OPT in
      o) OUTPUT_FILE=$OPTARG ;;
      a) FLAG=1 ;;
      ?) usage;;
    esac
  done

  shift $((OPTIND - 1))

  INPUT_FILE=${1:-}

  if [[ "$INPUT_FILE" == "" ]]; then
    usage
  fi
}

#
# 関数定義
#

function hoge() {
  local input_file="$1"
  cat <<EOS
  cat "$input_file"
EOS
}

function fuga() {
  local output_file="$1"
  cat <<EOS
  echo "Hello" > "$output_file"
EOS
}

function main() {
  local input_file="$1"
  local output_file="$2"
  local flab="$3"

  hoge "$input_file"
  fuga "$output_file"
}

# エントリー処理
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_args "$@"
  main "$OUTPUT_FILE" "$INPUT_FILE" "$FLAG"
fi
