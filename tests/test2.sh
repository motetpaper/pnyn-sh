#!/usr/bin/env bash

## test2.sh
PROG=$(basename $0)

msg() {
  echo "[$PROG] $1"
}


pnyn version
echo

msg '$ pnyn tonemarksiso han2 yu3 pin1 yin1'
pnyn tonemarksiso han2 yu3 pin1 yin1
echo


msg '$ pnyn tm han2 yu3 pin1 yin1'
pnyn tm han2 yu3 pin1 yin1
echo
