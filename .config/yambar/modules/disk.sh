#!/bin/sh

last_text=""
last_symbol=""

while true
do

  raw="$(df -h --output=pcent,used /dev/nvme0n1p3 | tail -1)"
  #percent="$(echo $raw | awk '{ print $1 }' | tr -d %)"
  usage="$(echo $raw | awk '{ print $2 }')"
  text="$usage"
  #text="$percent% $usage"
  symbol=""

  if test "$text" != "$last_text" || \
    test "$symbol" != "$last_symbol"
  then
    last_text="$text"
    echo "disk|string|$text"
    #echo "text|string|$text"
    #last_symbol="$symbol"
    #echo "symbol|string|$symbol"
    echo
  fi

  sleep 30
done
