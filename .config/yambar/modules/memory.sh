#!/bin/sh

last_text=""
last_symbol=""

while true
do

  raw_output="$(free -m | sed '2!d' | tr -s ' ' | cut -d' ' -f2,3)"
  #total="${raw_output% *}"
  usage="${raw_output#* }"
  #percent="$(( usage * 100 / total ))"
  text="${usage}MB"
  symbol=""

  if test "$text" != "$last_text" || \
    test "$symbol" != "$last_symbol"
  then
    last_text="$text"
    echo "memory|string|$text"
    #last_symbol="$symbol"
    #echo "symbol|string|$symbol"
    echo
  fi

  sleep 1
done
