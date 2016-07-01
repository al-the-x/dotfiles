#!/usr/bin/env bash

[[  -n "$(command -v git 2>/dev/null)" &&
    -n "$(command -v ruby 2>/dev/null)" &&
    -n "${GEM:-$(command -v gem 2>/dev/null)}"
]] || {
  echo 'Cannot find `git`'; exit 1
}

REMOTE="git@github.com:al-the-x/dotfiles.git"

{ $GEM install homesick &&
  homesick clone $REMOTE &&
  homesick link
}

## TODO: Determine platform (Debian/CentOS/MacOSX/Cygwin): `$OSTYPE`...?
case "$OSTYPE" in
  "darwin"*) echo 'I am MacOS X!' ;;
  "cygwin"*) echo 'I am Cygwin!' ;;
  "linux"*) echo 'True Linux, dog.' ;;
  "bsd"*) echo 'What, BSD?' ;;
  *) echo 'Who knows?' ;;
esac
## TODO: Install `brew` via Homebrew / Linuxbrew per platform
## TODO: Install and run `brew bundle`: `brew tap homebrew/bundle && brew bundle --global`
## TODO: Install global python packages
## TODO: Install global ruby gems