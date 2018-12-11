#!/usr/bin/env bash

[[  -n "$(command -v git 2>/dev/null)" &&
    -n "$(command -v ruby 2>/dev/null)" &&
    -n "$(command -v gem 2>/dev/null)"
]] || {
  echo 'You need `git` and `ruby` installed, yo...'; exit 1
}

function debug-msg {
  echo $@ >&2
}

## Look for `brew` in all the usual suspects...
function find-brew {
    local location="$(command -v brew 2>/dev/null)"
    
    [[ -z "$location" ]] && {
        for location in ("/usr/local" "${XDG-HOME:-$HOME}/.linuxbrew" "/home/linuxbrew/.linuxbrew"); do
          if [[ -d "$location" ]] && [[ -x "$location/bin/brew" ]]; then
            echo "$location/bin/brew"
            return
          fi
        done
    }

    echo "$location"
}

## Determine platform (Debian/CentOS/MacOSX/Cygwin) via `$OSTYPE`
function install-brew {
    case "$OSTYPE" in
      "darwin"*) debug-msg 'I am MacOS X!'
        ## So install Homebrew already...
        /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      ;;
      
      "linux"*) debug-msg 'True Linux, dog.' 
        ## Thanks, how about some Linuxbrew...
        /usr/bin/env ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
      ;;
      
      ## TODO: Do something on Cygwin one day...
      "cygwin"*) debug-msg 'I am Cygwin!'
        return 1 # not implemented
      ;;
      
      ## TODO: Do something on pure BSD one day...
      "bsd"*) debug-msg 'What, BSD?'
        return 1 # not implemented
      ;;
      
      ## TODO: Fail miserably?
      *) debug-msg 'Who knows?'
        return 255 # okay, wtf?
      ;;
    esac
    
    find-brew;
}

find-brew || install-brew

BREW="$(find-brew)"

[[ -z "$BREW" ]] && {
    echo 'Cannot find `brew`'
    exit 1
}

## - `brew bundle` needs `ruby >2` not installed by Max OSX >_<
## - `Brewfile` lives in `al-the-x/dotfiles` installed via `homeshick`
$BREW install ruby homeshick

## Install and link "castles"...
HOMESHICK="$($BREW --prefix homeshick)/bin/homeshick"
for repo in 'al-the-x/dotfiles'; do
    $HOMESHICK clone $repo
    $HOMESHICK link $repo
done

## Install formulae listed in `Brewfile` (linked via `homesick`)
$BREW tap homebrew/bundle && brew bundle --global

## TODO: Install global npm packages
## TODO: Install global python packages
## TODO: Install global ruby gems
