#!/bin/bash

# Fast fail the script on failures.
set -e

# Check arguments.
TASK=$1

if [ -z "$PKG" ]; then
  echo -e '\033[31mPKG argument must be set!\033[0m'
  exit 1
fi

if [ -z "$TASK" ]; then
  echo -e '\033[31mTASK argument must be set!\033[0m'
  exit 1
fi

# Navigate to the correct sub-directory, and run "pub upgrade".
pushd $PKG
PUB_ALLOW_PRERELEASE_SDK=quiet pub get
EXIT_CODE=1

case $TASK in

presubmit)
    dartfmt lib/ --line-length=120 --set-exit-if-changed -n
    dartfmt test/ --line-length=120 --set-exit-if-changed -n
    pub run build_runner build
    dartanalyzer --fatal-warnings --no-hints --no-lints .
    ;;

test)
    pub run build_runner test -- -p chrome
    ;;

  *)
   echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
   exit 1
   ;;
esac