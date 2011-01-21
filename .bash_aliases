#!/bin/bash

export DEPLOYMENT=local

##
 # The svn_repo() function returns the repository root URL of the provided
 # working copy, assuming "./" if omitted. This is useful for svn < 1.6.x,
 # which doesn't implement the "^/" shortcut for repository URLs.
##
svn_repo ( )
{
	svn info $1 | grep Root | sed -r 's/^.*: //'
} ## END svn_repo

psql_proc ( )
{
    psql $@ -c 'SELECT "procpid", "current_query", (now() - "query_start") as "runtime" FROM "pg_stat_activity";'
}

if [ !`which editor` ]; then
    export EDITOR=`which vim`
fi

alias can-has="apt-get"

alias manage="./project/manage.py"

alias activate="source ./bin/activate"

