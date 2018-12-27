#!/usr/bin/env bash

# variables
ROOT_DIR=$(cd $(dirname $0); pwd)

# functions
_usage() {
  echo "usage:"
  echo "${0} [-x execute]"
  exit 1
}
_sync() {
  mkdir -p ${HOME}/.ssh
  rm -f ${HOME}/.ssh/authorized_keys.new
  for url in "${KEYS_URLS[@]}"; do
    wget ${url} -O - >> ${HOME}/.ssh/authorized_keys.new
  done

  if [ ! -e ${HOME}/.ssh/authorized_keys ]; then
    if [ "${flag_exec}" == "TRUE" ]; then
      mv ${HOME}/.ssh/authorized_keys.new ${HOME}/.ssh/authorized_keys
    else
      rm -f ${HOME}/.ssh/authorized_keys.new
    fi
    echo "create authorized_keys"
    return
  fi
  diff ${HOME}/.ssh/authorized_keys ${HOME}/.ssh/authorized_keys.new > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    if [ "${flag_exec}" == "TRUE" ]; then
      mv ${HOME}/.ssh/authorized_keys ${HOME}/.ssh/authorized_keys.bk$(date +"%Y%m%d.%H%M%S.%6N")
      mv ${HOME}/.ssh/authorized_keys.new ${HOME}/.ssh/authorized_keys
      chmod 600 $HOME/.ssh/authorized_keys
    else
      rm -f ${HOME}/.ssh/authorized_keys.new
    fi
    echo "update authorized_keys"
    return
  fi

  rm -f ${HOME}/.ssh/authorized_keys.new
  echo "no update authorized_keys"
  return
}

# option
while getopts x opt
do
  case ${opt} in
  "x" )
    flag_exec="TRUE"
    ;;
  :|\?) _usage;;
  esac
done


# main

if [ ! -e "${ROOT_DIR}/keys-urls" ]; then
  echo "not found ${ROOT_DIR}/keys-urls"
  exit
fi
source "${ROOT_DIR}/keys-urls"

if [ ${#KEYS_URLS[*]} -eq 0 ]; then
  echo "keys_urls is empty"
  exit
fi

if [ "${flag_exec}" != "TRUE" ]; then
  echo "***** dry-run *****"
fi
_sync
