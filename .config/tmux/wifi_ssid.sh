#!/bin/bash
# @date Time-stamp: <2021-01-22 19:29:42 tagashira>
# @file wifi_ssid.sh
# @brief

function network() {
  if $(command -v iwconfig > /dev/null 2>&1)
  then
    # Check online
    info=( $(iwconfig 2> /dev/null | grep -E -i "(quality|state|lastTxRate|essid)") )
    if [[ ${#info[@]} -eq 0 ]]; then
      echo "offline"
    else
      # Get the wifi ssid
      ssid="$(iwconfig 2> /dev/null |grep -i ESSID |cut -d: -f2 |xargs echo)"
      echo -e "$ssid"
    fi
  else
    ssid=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep -e "^ *SSID" | cut -d':' -f2 | sed 's# ##g')
    echo "$ssid"
  fi
}

function is_online(){
  ping -c 1 -q google.com
  echo $?
}

function main() {
  local SMALL=80
  local MEDIUM=140

  if [[ $1 -gt $MEDIUM ]];then
      echo -n "$(network)"
  elif [[ $1 -gt $SMALL ]];then
    echo -n "$(network |head -c6)"
  else
    echo -n "$(network)"
  fi

  if [ "is_online()" -ne 0 ] ;then
    echo -n ":#{online_status}"
  fi
}

main $1
