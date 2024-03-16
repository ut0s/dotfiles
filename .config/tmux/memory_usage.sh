#!/bin/bash
# @file memory_usage.sh
# @brief

#fg color
mem_low_fg_color="#[fg=green]"
mem_medium_fg_color="#[fg=yellow]"
mem_high_fg_color="#[fg=red]"

#bg color
mem_low_bg_color="#[bg=green]"
mem_medium_bg_color="#[bg=yellow]"
mem_high_bg_color="#[bg=red]"


# is second float bigger?
fcomp() {
    awk -v n1=$1 -v n2=$2 'BEGIN {if (n1<n2) exit 0; exit 1}'
}


mem_usage(){
  if $(command -v free > /dev/null 2>&1)
  then
    free -h | awk '/Mem:/ {print $3 "/" $2}' |sed 's#G##'
  else
    local memory=$(top -l 1 | grep "PhysMem" | cut -d' ' -f2 | numfmt --from=iec --to=iec | sed 's#G##')
    local total=$(sysctl hw.memsize | cut -d' '  -f2 | numfmt --to=iec)
    echo  "$memory/$total"
  fi
}


mem_percentage(){
  if $(command -v free > /dev/null 2>&1)
  then
    free -m | awk '/Mem:/ {printf "%2d\n",100*$3/$2}'
  else
    local memory=$(top -l 1 | grep "PhysMem" | cut -d' ' -f2 | numfmt --from=iec)
    local total=$(sysctl hw.memsize | cut -d' '  -f2)
    local num=$(( 100 * $memory / $total ))
    echo $num
  fi
}


mem_use_status() {
    local percentage=$1
    if fcomp 80 $percentage; then
        echo "high"
    elif fcomp 30 $percentage && fcomp $percentage 80; then
        echo "medium"
    else
        echo "low"
    fi
}


print_fg_color() {
    local mem_percentage=$(mem_percentage)
    local mem_status=$(mem_use_status $mem_percentage)
    if [ $mem_status == "low" ]; then
        echo "$mem_low_fg_color"
    elif [ $mem_status == "medium" ]; then
        echo "$mem_medium_fg_color"
    elif [ $mem_status == "high" ]; then
        echo "$mem_high_fg_color"
    fi
}


print_bg_color() {
    local mem_percentage=$(mem_percentage)
    local mem_status=$(mem_use_status $mem_percentage)
    if [ $mem_status == "low" ]; then
        echo "$mem_low_bg_color"
    elif [ $mem_status == "medium" ]; then
        echo "$mem_medium_bg_color"
    elif [ $mem_status == "high" ]; then
        echo "$mem_high_bg_color"
    fi
}


test1(){
echo "fcomp test"
$(fcomp 0 1.2) && echo OK
$(fcomp 1.2 0) || echo OK
}


test2(){
echo "memory status test"
test $(mem_use_status 12) == "low" && echo OK
test $(mem_use_status 44) == "medium" && echo OK
test $(mem_use_status 88) == "high" && echo OK
}

# test1
# test2

function main() {
    local SMALL=80
    local MEDIUM=140

    if [[ $1 -gt $MEDIUM ]];then
        echo $(print_bg_color) Mem:$(mem_usage)
    elif [[ $1 -gt $SMALL ]];then
        echo $(print_bg_color)$(mem_usage)
    else
        echo $(print_bg_color)$(mem_usage)|sed 's#G##g'
    fi
}
main $1
