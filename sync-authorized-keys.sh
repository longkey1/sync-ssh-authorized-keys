#!/usr/bin/env bash

# variables
readonly ROOTDIR=$(cd $(dirname $0); pwd)
readonly PROCNAME=${0##*/}
readonly LOGFILE="$ROOTDIR/${PROCNAME}.log"
DRY_RUN=""
if [ $# == 1 ] && [ $1 == "--dry-run" ]; then
    DRY_RUN="***DRY RUN*** "
fi

# functions
function _log() {
  echo -e "$(date '+%Y-%m-%dT%H:%M:%S') ${DRY_RUN}$@"| tee -a ${LOGFILE}
}
function _sync() {
  mkdir -p ${HOME}/.ssh
  rm -f ${HOME}/.ssh/authorized_keys.new
  for url in "${KEYSURLS[@]}"; do
    wget ${url} -q -O - >> ${HOME}/.ssh/authorized_keys.new
  done

  if [ ! -e ${HOME}/.ssh/authorized_keys ]; then
    if [ -z "${DRY_RUN}" ]; then
      mv ${HOME}/.ssh/authorized_keys.new ${HOME}/.ssh/authorized_keys
    else
      rm -f ${HOME}/.ssh/authorized_keys.new
    fi
    _log "create authorized_keys"
    return
  fi
  diff ${HOME}/.ssh/authorized_keys ${HOME}/.ssh/authorized_keys.new > /dev/null 2>&1
  if [ $? -eq 1 ]; then
    if [ -z "${DRY_RUN}" ]; then
      mv ${HOME}/.ssh/authorized_keys ${HOME}/.ssh/authorized_keys.bk$(date +"%Y%m%d.%H%M%S.%6N")
      mv ${HOME}/.ssh/authorized_keys.new ${HOME}/.ssh/authorized_keys
      chmod 600 $HOME/.ssh/authorized_keys
    else
      rm -f ${HOME}/.ssh/authorized_keys.new
    fi
    _log "update authorized_keys"
    return
  fi

  rm -f ${HOME}/.ssh/authorized_keys.new
  _log "no change authorized_keys"
  return
}



# main

if [ ! -e "${ROOTDIR}/keys-urls" ]; then
  _log "not found ${ROOTDIR}/keys-urls"
  exit
fi
source "${ROOTDIR}/keys-urls"

if [ ${#KEYSURLS[*]} -eq 0 ]; then
  _log "keys_urls is empty"
  exit
fi

_sync
