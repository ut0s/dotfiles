#!/bin/bash
# @date Time-stamp: <2021-01-22 19:29:42 tagashira>
# @file wifi_ssid.sh
# @brief

function network() {
  if command -v iwconfig > /dev/null 2>&1
  then
    # Check online
    if ! iwconfig 2> /dev/null | grep -E -i -q "(quality|state|lastTxRate|essid)"; then
      echo "offline"
    else
      # Get the wifi ssid
      ssid="$(iwconfig 2> /dev/null | grep -i ESSID | cut -d: -f2 | xargs echo)"
      echo "$ssid"
    fi
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    ssid="$(macos_ssid)"
    if [[ -n "$ssid" ]]; then
      echo "$ssid"
    else
      echo "offline"
    fi
  else
    echo "offline"
  fi
}

function macos_wifi_device() {
  networksetup -listallhardwareports 2> /dev/null |
    awk '/^Hardware Port: (Wi-Fi|AirPort)$/ { getline; if ($1 == "Device:") { print $2; exit } }'
}

function macos_ssid_from_networksetup() {
  local device
  local output

  device="$(macos_wifi_device)"
  if [[ -z "$device" ]]; then
    return 1
  fi

  output="$(networksetup -getairportnetwork "$device" 2> /dev/null)"
  if [[ "$output" == *": "* ]]; then
    echo "${output#*: }"
  else
    return 1
  fi
}

function macos_ssid_from_system_profiler() {
  system_profiler SPAirPortDataType 2> /dev/null |
    awk '
      /Current Network Information:/ {
        getline
        sub(/^[[:space:]]+/, "")
        sub(/:$/, "")
        if ($0 != "") print
        exit
      }
    '
}

function macos_ssid() {
  macos_ssid_from_networksetup || macos_ssid_from_system_profiler
}

function is_online(){
  ping -c 1 -q google.com > /dev/null 2>&1
}

function main() {
  local SMALL=80
  local MEDIUM=140
  local width="${1:-0}"

  if [[ $width -gt $MEDIUM ]];then
      echo -n "$(network)"
  elif [[ $width -gt $SMALL ]];then
    echo -n "$(network |head -c6)"
  else
    echo -n "$(network)"
  fi

  if ! is_online ;then
    echo -n ":#{online_status}"
  fi
}

main "$1"
