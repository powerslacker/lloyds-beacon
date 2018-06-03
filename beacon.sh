#!/bin/bash

# handle user input
case $1 in 
  add) add $2;;
  rm) remove $2;;
  list) list;;
  *) jump $1;;
esac;

# adds the current directory to the beacon list via its name
add() {
  local name="$1"
  local foundBeacon=$(findBeacon "$name")
  if [[ -z "$foundBeacon" ]]; then
    echo "created beacon: $name => $(pwd)"
    echo "$name:$(pwd)" >> ~/.beacons
  else
    echo "failed to create beacon: you already have a beacon named $name"
  fi
}

# removes a beacon from the list via its name
remove() {
  local name="$1"
  $(sed -i "/$name:/d" ~/.beacons)
  echo "removed beacon $name"
}

# jumps to a beacon directory via its name
jump() {
  local name="$1"
  local foundBeacon=$(findBeacon "$name")
  # check that the beacon exists
  if [[ -z "$foundBeacon" ]]; then
    echo "no beacon named $name"
    return
  fi
  # split the beacon into parts based on colon delimiter
  local arr=()
  while IFS= read -d : -r field || [ -n "$field" ]; do
    arr+=("$field")
  done <<< "$foundBeacon"
  # cleanup new lines from grepped text
  cleaned=${arr[2]//[$'\n']}
  # change to the directory for the given beacon
  cd $cleaned
}

# prints the beacons file to the terminal
list() {
  cat ~/.beacons
}

# helper func to find a beacon in the file
findBeacon() {
  echo "$(grep $1: ~/.beacons)"
}