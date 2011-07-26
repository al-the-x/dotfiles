#!/bin/bash

export DEPLOYMENT=local

export LESS="RX"

##
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

[[ "$(which editor)" ]] || export EDITOR=$(which vim)

alias tmux="tmux -f ~/.tmuxrc"

alias can-has="apt-get"

alias activate="source ./bin/activate"

alias gvims="gvim --servername $(basename $PWD) --remote-tab-silent"

