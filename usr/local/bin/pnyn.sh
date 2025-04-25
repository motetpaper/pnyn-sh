#!/usr/bin/env bash

## pnyn.sh
## job  : convert Chinese characters to Hanyu Pinyin
## git  : https://github.com/motetpaper/pnyn-sh
## lic  : MIT

motet_inpinyin() {

  indata="$1"
  outdata="$1"
  hpdata="/usr/share/motetpaper/pnyn/hp.txt"

  while IFS=' ' read -r hz py; do
    outdata="${outdata/$hz/$py }"
  done < $hpdata

  # trim extra spaces
  echo $outdata | xargs
}

motet_inpinyin $1
