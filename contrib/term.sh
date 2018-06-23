#!/bin/bash

if [ -z "$1" ]; then
  echo "$(basename $0) <node-name>" 1>&2
  exit 1
fi

NODE=${1}

PID=$(docker exec -it p4-tutorials ps ax | grep mininet:${NODE} | awk '{print $1}')

CMD="docker exec -it p4-tutorials sudo mnexec -a ${PID} env NODENAME=${NODE} bash && exit 0"

if [ "${TERM_PROGRAM}" = "Apple_Terminal" ] ; then
  osascript <<END
    tell application "Terminal"
      set currentTab to do script "${CMD}"
    end tell
END
elif [ "${TERM_PROGRAM}" = "iTerm.app" ] ; then
  VERSION=$(osascript -e 'tell application "iTerm" to version')
  VERSION=($(echo ${VERSION} | tr -s '.' ' '))
  WINDOW="window"
  if [[ ${VERSION[0]} -lt 2 ]]; then
    WINDOW="terminal"
  elif [[ (${VERSION[0]} -eq 2) && (${VERSION[1]} -lt 9) ]]; then
    WINDOW="terminal"
  fi
  osascript <<END
    tell application "iTerm"
      tell application "System Events" to keystroke "d" using {shift down, command down}
      tell the current session of current ${WINDOW} to write text "${CMD}"
      tell application "System Events" to keystroke "[" using {command down}
    end tell
END
else
  eval "${CMD}"
fi
