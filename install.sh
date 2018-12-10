#!/usr/bin/env bash

[[  -n "$(command -v git 2>/dev/null)" &&
    -n "$(command -v ruby 2>/dev/null)" &&
    -n "$(command -v gem 2>/dev/null)"
]] || {
  echo 'You need `git` and `ruby` installed, yo...'; exit 1
}

## TODO: Determine platform (Debian/CentOS/MacOSX/Cygwin): `$OSTYPE`...?
case "$OSTYPE" in
  "darwin"*) echo 'I am MacOS X!'
    ## So install Homebrew already...
    /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  ;;
  "cygwin"*) echo 'I am Cygwin!' ;;
  "linux"*) echo 'True Linux, dog.'
    ## Thanks, how about some Linuxbrew...
    /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  ;;
  "bsd"*) echo 'What, BSD?' ;;
  *) echo 'Who knows?' ;;
esac

## Look for `brew` in all the usual suspects...
local BREW_LOCATIONS=("/usr/local" "${XDG-HOME:-$HOME}/.linuxbrew" "/home/linuxbrew/.linuxbrew")
for BREW_PATH in $BREW_LOCATIONS; do
  [[ -d "$BREW_PATH" ]] && [[ -x "$BREW_PATH/bin/brew" ]] && {
    eval "$($BREW_PATH/bin/brew shellenv)"
  }
done

[[ -z "$(command -v brew 2>/dev/null)" ]] && {
    brew tap homebrew/bundle && brew bundle --global
} || {
    echo 'Cannot find `brew`'; exit 1
}

## TODO: Install `ruby` via `brew` because `brew bundle` requires `ruby > 2.x` >_<
{ gem install homesick --user-install &&
  command -v homesick &&
  homesick clone al-the-x/dotfiles &&
  homesick link
}

## TODO: Install global npm packages
## TODO: Install global python packages
## TODO: Install global ruby gems
