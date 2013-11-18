#!/bin/bash

export DEPLOYMENT=local

export LESS="RX"

###
 # Useful function for setting $PS1 with human-readable variables.
prompt ( )
{
    [[ ($# > 0) ]] || return

    color="tput setaf"

    local NONE=$(tput sgr0)
    local BOLD=$(tput bold)

    local BLACK=$($color 0)
    local RED=$($color 1)
    local GREEN=$($color 2)
    local YELLOW=$($color 3)
    local BLUE=$($color 4)
    local MAGENTA=$($color 5)
    local CYAN=$($color 6)
    local WHITE=$($color 7)

    eval "echo \"$@\""
}

###
 # The svn_repo() function returns the repository root URL of the provided
 # working copy, assuming "./" if omitted. This is useful for svn < 1.6.x,
 # which doesn't implement the "^/" shortcut for repository URLs.
##
svn_repo ( )
{
	svn info $1 | grep Root | sed -r 's/^.*: //'
} ## END svn_repo

## Display the process list for PostgreSQL...
psql_proc ( )
{
    psql $@ -c 'SELECT "procpid", "current_query", (now() - "query_start") AS "runtime" FROM "pg_stat_activity";'
}

## Display the process list for MySQL...
mysql_proc ( )
{
    mysql $@ -e 'SHOW FULL PROCESSLIST'
}

## Correct the SSH environment after reconnecting to a tmux session...
ssh_fix ( )
{
    if [[ "$TMUX" && "$SSH_CONNECTION" ]]; then
        eval $(tmux showenv | grep -v ^- | sed -e 's/=\(.*\)/="\1"/' -e 's/^/export /')
    fi
}

##
 # Initialize a GVIM "server" with the supplied filesystem paths in tabs or add
 # those paths to the tabs of a running instance.
 ##
gvims ( )
{
    GVIM="gvim --servername $(basename $PWD)"

    [[ "$@" ]] && $GVIM --remote-tab-silent $@ || $GVIM
}


## If VIM is available, always use that as my editor. ALWAYS.
if [[ "$(which vim)" ]]; then
    export EDITOR=$(which vim)
    alias editor=$EDITOR
fi

## I prefer ".tmuxrc" to ".tmux.conf"...
alias tmux="tmux -f ~/.tmuxrc"

## For da LOLZ...
alias can-has="apt-get"

## Activate the (Python) virtualenv wrapper, if it exists...
alias activate="source ./bin/activate"

## Give git Github-enabled superpowers...
alias git=hub

alias rb=rbenv

alias json="python -m json.tool"
alias httpd="python -m SimpleHTTPServer"
>>>>>>> I thought I had these aliases defined already.
