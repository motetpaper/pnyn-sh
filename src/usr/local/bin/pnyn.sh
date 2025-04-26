#!/usr/bin/env bash

## pnyn v0.8.1
## job    : provides command-line pinyin processing for Ubuntu Linux
## git    : https://github.com/motetpaper/pnyn-sh
## lic    : MIT
##


## text decorations
REDRED="\033[31m"
RS="\033[0m"
B_ON="\e[1m"
B_OFF="\e[0m"

aboutbox() {
  echo "pnyn, hanyu pinyin tools, v0.8.1, MOTETPAPER (C) 2025, MIT License";
}

## displays command line options
usage() {
  PROMPT_A="Available commands for PNYN services"
  echo -e "
${B_ON}${PROMPT_A}${B_OFF}

    pnyn version
    pnyn -v

    pnyn help
    pnyn -h

    pnyn pinyin STRING
    pnyn tonemarks STRING
    pnyn tonemarksiso STRING
    pnyn notones STRING

    pnyn pmash STRING
    pnyn pbash STRING
"

}

## converts chinese to hanyu pinyin using CC-CEDICT dictionary data
pnyn_cmd_pinyin() {

  indata="$1"
  outdata="$1"
  hpdata="/usr/share/motetpaper/pnyn/hp.txt"

  while IFS=' ' read -r hz py; do
    outdata="${outdata/$hz/$py }"
  done < $hpdata

  # trim extra spaces
  echo $outdata | xargs
}

## converts tone numbers to ISO-compliant tone marks
pnyn_cmd_tonemarksiso() {

  indata="$1"
  outdata="$1"
  tmisodata="/usr/share/motetpaper/pnyn/tmiso.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with ISO-compliant tone marks
  while IFS=' ' read -r tn tmiso; do
    outdata="${outdata/$tn/$tmiso }"
  done < $tmisodata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata/$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}

## converts tone numbers to (legacy) tone marks
pnyn_cmd_tonemarks() {

  indata="$1"
  outdata="$1"
  tmdata="/usr/share/motetpaper/pnyn/tm.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with tone marks
  while IFS=' ' read -r tn tm; do
    outdata="${outdata/$tn/$tm }"
  done < $tmdata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata/$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}

## removes all tones from recognized pinyin tonemes
pnyn_cmd_tonesremoved() {
  indata="$1"
  outdata="$1"
  trdata="/usr/share/motetpaper/pnyn/tr.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with tone marks
  while IFS=' ' read -r tn tr; do
    outdata="${outdata/$tn/$tr }"
  done < $trdata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata/$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}

### metapinyin idioms area
### metapinyin makes pinyin documents more searchable

# removes spaces, then diacritics
pnyn_cmd_pmash() {
  echo "$1" | tr -d [[:space:]] | iconv -f utf8 -t ascii//TRANSLIT
  echo
}

# removes spaces and diacritics, then digits
pnyn_cmd_pbash() {
  echo $(pnyn_cmd_pmash "$1") | tr -d [[:digit:]]
}

## command area
pnyn_cmd() {
#  echo $0 $1 # debug
#  echo $@ # debug
  if [[ -z "$1" ]]; then
    echo -e "${REDRED}ERROR:${RS}$PROG Command name argument expected.";
    usage
  else

    ## shows version, then exits
    if [[ "version" == $1 || "-v" == $1 ]];then
      aboutbox
      return
    fi

    ## shows version info, then command list, then exits
    if [[ "help" == $1 || "-h" == $1 ]];then
      aboutbox
      usage
      return
    fi

    if [[ "notones" == $1 || "tonesremoved" == $1 || "tr" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.tonesremoved] Command name argument expected.";
        usage
      else
        foo="${@:2}"
        pnyn_cmd_tonesremoved "${foo[*]}"
      fi

      return
    fi

    if [[ "tonemarks" == $1 || "tm" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.tonemarks] String input expected.";
        echo "
        Try this: $ pnyn tonemarks ni3 hao3
        "
      else
        foo="${@:2}"
        pnyn_cmd_tonemarks "${foo[*]}"
      fi

      return
    fi

    if [[ "tonemarksiso" == $1 || "tmiso" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.tonemarksiso] String input expected.";
        echo "
        Try this: $ pnyn tonemarksiso ni3 hao3
        "
      else
        foo="${@:2}"
        pnyn_cmd_tonemarksiso "${foo[*]}"
      fi

      return
    fi

    if [[ "pinyin" == $1 || "p" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.pinyin``] String input expected.";
        echo "
        Try this: $ pnyn pinyin ni3 hao3
        "
      else
        foo="${@:2}"
        pnyn_cmd_pinyin "${foo[*]}"
      fi

      return
    fi

    if [[ "pmash" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.pmash] String input expectedd.";
        usage
      else
        foo="${@:2}"
        pnyn_cmd_pmash "${foo[*]}"
      fi

      return
    fi

    if [[ "pbash" == $1 ]];then

      if [[ -z "$2" ]]; then
        echo -e "${REDRED}ERROR:${RS}[pnyn.pbash] String input expectedd.";
        usage
      else
        foo="${@:2}"
        pnyn_cmd_pbash "${foo[*]}"
      fi

      return
    fi

    ## if you made it down here,
    ## something went wrong ...

    echo -e "${REDRED}ERROR:${RS}$PROG Command name argument not found.";
    usage
    return
  fi
}

pnyn_cmd $@

