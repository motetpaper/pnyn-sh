#!/usr/bin/env bash
##
## pnyn v0.8.8
## job    : provides command-line pinyin processing for Ubuntu Linux
## git    : https://github.com/motetpaper/pnyn-sh
## lic    : MIT
##
##
##
##

###
### message area
###
###
###
PROG=$(basename $0)
VERSION="v0.8.8"

## text decorations
REDRED="\033[31m"
RS="\033[0m"
B_ON="\e[1m"
B_OFF="\e[0m"

msg() {
  echo "$1"
  echo
}

info_msg() {
  echo "[$PROG] try this: $ $1"
  echo
}

## prints to stderr
err_msg() {
  echo -e "[$PROG] ${REDRED}ERROR:${RS}$1" >&2
  echo
}

###
### help area
###
###
###

aboutbox() {
  echo "pnyn, hanyu pinyin tools, ${VERSION}, MOTETPAPER (C) 2025, MIT License";
}

## displays command line options
usage() {
  PROMPT_A="Available commands for PNYN services"
  echo -e "${B_ON}${PROMPT_A}${B_OFF}

    pnyn pinyin STRING
    pnyn tonemarks STRING
    pnyn tonemarksiso STRING
    pnyn notones STRING

    pnyn version
    pnyn -v

    pnyn help
    pnyn -h

    LEARN MORE: man pnyn
"
}


###
### conversion area
###
###
###

pnyn_remove_pinyin_ascii() {
  ## removes numbers and letters, and umlaut colon
  ## removes leading and trailing spaces
  echo $(echo "$1" | tr -d [[:alnum:]] | tr -d ':' | xargs )
}

## converts chinese to hanyu pinyin using CC-CEDICT dictionary data
pnyn_cmd_pinyin() {

  indata="$1"
  outdata="$1"
  hpdata="/usr/share/motetpaper/pnyn/hp.txt"

  while IFS=' ' read -r hz py; do
    outdata="${outdata//$hz/$py }"
  done < $hpdata

  # trim extra spaces
  echo $outdata | xargs
}

## converts tone numbers to ISO-compliant tone marks
pnyn_cmd_tonemarksiso() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  indata="$str"
  outdata="$str"
  tmisodata="/usr/share/motetpaper/pnyn/tmiso.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with ISO-compliant tone marks
  while IFS=' ' read -r tn tmiso; do
    outdata="${outdata//$tn/$tmiso }"
  done < $tmisodata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata//$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}

## converts tone numbers to (legacy) tone marks
pnyn_cmd_tonemarks() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  indata=$str
  outdata=$str
  tmdata="/usr/share/motetpaper/pnyn/tm.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with tone marks
  while IFS=' ' read -r tn tm; do
    outdata="${outdata//$tn/$tm }"
  done < $tmdata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata//$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}

## removes all tones from recognized pinyin tonemes
pnyn_cmd_tonesremoved() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  indata="$str"
  outdata="$str"
  trdata="/usr/share/motetpaper/pnyn/tr.txt"
  tfdata="/usr/share/motetpaper/pnyn/tf.txt"

  ## replaces tone with tone marks
  while IFS=' ' read -r tn tr; do
    outdata="${outdata//$tn/$tr }"
  done < $trdata

  ## removes tone5
  while IFS=' ' read -r tx tf; do
    outdata="${outdata//$tx/$tf }"
  done < $tfdata

  # trim extra spaces
  echo $outdata | xargs
}


###
### metapinyin idioms area
### metapinyin makes pinyin documents more searchable
###
###
###

# PMASH removes spaces
pnyn_cmd_pmash() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  echo $str | tr -d [[:blank:]]
}

## PBASH removes tone marks, tone numbers, and spaces
pnyn_cmd_pbash() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  echo $(pnyn_cmd_tonesremoved "$str" | tr -d [[:space:]])
}


## PSMASH returns the initials of each pinyin word
pnyn_cmd_psmash() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  psmash=""
  IFS=' ' read -r -a arr <<< $str
  for i in $(seq 1 ${#arr[@]}); do
    psmash=$psmash${arr[i-1]:0:1}
  done

  echo $psmash | xargs
}

## DEVELOPER NOTES:
## PSLUG is designed for use with the WordPress
## wp_unique_post_slug function that creates user-friendly URLS
##
## PSLUG removes tone marks, tone numbers, and replaces
## horizontal spaces with dashes.
##
## See the WordPress codex for details:
## https://developer.wordpress.org/reference/functions/wp_unique_post_slug/

pnyn_cmd_pslug() {

  str=""
  if [[ -z $(pnyn_remove_pinyin_ascii "$1" ) ]]; then
    str="$1"
  else
    str=$(pnyn_cmd_pinyin "$1")
  fi

  echo $(pnyn_cmd_tonesremoved "$str" | xargs | tr [[:blank:]] '-')
}

##
## command area
##
##
##

pnyn_cmd() {
#  echo $0 $1 # debug
#  echo $@ # debug
  if [[ -z "$1" ]]; then
    err_msg "Command name argument expected."
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
        err_msg "[pnyn.tonesremoved] String input expected.";
        info_msg "pnyn tonesremoved ni3 hao3"
        usage
      else
        foo="${@:2}"
        pnyn_cmd_tonesremoved "${foo[*]}"
      fi

      return
    fi

    if [[ "tonemarks" == $1 || "tm" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.tonemarks] String input expected.";
        info_msg "pnyn tonemarks ni3 hao3"
      else
        foo="${@:2}"
        pnyn_cmd_tonemarks "${foo[*]}"
      fi

      return
    fi

    if [[ "tonemarksiso" == $1 || "tmiso" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.tonemarksiso] String input expected.";
        info_msg "pnyn tonemarksiso ni3 hao3"
      else
        foo="${@:2}"
        pnyn_cmd_tonemarksiso "${foo[*]}"
      fi

      return
    fi

    if [[ "pinyin" == $1 || "p" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.pinyin] String input expected.";
        info_msg "pnyn pinyin 生日快乐"
      else
        foo="${@:2}"
        pnyn_cmd_pinyin "${foo[*]}"
      fi

      return
    fi

    if [[ "pmash" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.pmash] String input expected.";
        info_msg "pnyn psmash sheng1 ri4 kuai4 le4"
        usage
      else
        foo="${@:2}"
        pnyn_cmd_pmash "${foo[*]}"
      fi

      return
    fi

    if [[ "pbash" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.pbash] String input expected.";
        info_msg "pnyn pbash sheng1 ri4 kuai4 le4"
        usage
      else
        foo="${@:2}"
        pnyn_cmd_pbash "${foo[*]}"
      fi

      return
    fi

    if [[ "psmash" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.psmash] String input expectedd.";
        info_msg "pnyn psmash sheng1 ri4 kuai4 le4"
        usage
      else
        foo="${@:2}"
        pnyn_cmd_psmash "${foo[*]}"
      fi

      return
    fi


    if [[ "pslug" == $1 ]];then

      if [[ -z "$2" ]]; then
        err_msg "[pnyn.slug] String input expectedd.";
        info_msg "pnyn pslug 生日快乐"
        usage
      else
        foo="${@:2}"
        pnyn_cmd_pslug "${foo[*]}"
      fi

      return
    fi

    ## if you made it down here,
    ## something went wrong ...

    err_msg "Command name argument not found."
    usage
    return
  fi
}

pnyn_cmd "$@"

