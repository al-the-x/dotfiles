#!/usr/bin/env bash

[[  -n "$(command -v git 2>/dev/null)" &&
    -n "$(command -v ruby 2>/dev/null)" &&
    -n "$(command -v gem 2>/dev/null)"
]] || {
  echo 'You need `git` and `ruby` installed, yo...'; exit 1
}

REMOTE="git@github.com:al-the-x/dotfiles.git"

{ gem install homesick &&
  homesick clone $REMOTE &&
  homesick link
}

## TODO: Determine platform (Debian/CentOS/MacOSX/Cygwin): `$OSTYPE`...?
case "$OSTYPE" in
  "darwin"*) echo 'I am MacOS X!'
    ## So install Homebrew already...
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ;;
  "cygwin"*) echo 'I am Cygwin!' ;;
  "linux"*) echo 'True Linux, dog.'
    ## Thanks, how about some Linuxbrew...
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  ;;
  "bsd"*) echo 'What, BSD?' ;;
  *) echo 'Who knows?' ;;
esac
## TODO: Install `brew` via Homebrew / Linuxbrew per platform

[[ -z "$(command -v brew 2>/dev/null)" ]] && {
    brew tap homebrew/bundle && brew bundle --global
}

## TODO: Install global npm packages
## TODO: Install global python packages
## TODO: Install global ruby gems
