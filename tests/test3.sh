#!/usr/bin/env bash

## test3.sh
PROG=$(basename $0)

msg() {
  echo "[$PROG] $1"
}

# controlfile
VER_A="v"$(cat src/DEBIAN/control | grep Version | cut -d' ' -f2)

# other files
VER_B=$(pnyn version | cut -d',' -f3 | xargs)
VER_C=$(cat src/usr/share/man/man1/pnyn.1 | grep ".B v" | cut -d' ' -f2)

msg 'controlfile version'
msg $VER_A

echo
echo

msg 'checking pnyn app version'
if [[ $VER_A == $VER_B ]]; then
  msg "PASS, $VER_A and $VER_B match"
else
  msg "FAILED, controlfile mismatch"
  msg "should be $VER_A, not $VER_B"
fi

echo
echo

msg 'checking pnyn manual version'
if [[ $VER_A == $VER_C ]]; then
  msg "PASS, $VER_A and $VER_C match"
else
  msg "FAILED, controlfile mismatch"
  msg "should be $VER_A, not $VER_C"
fi
