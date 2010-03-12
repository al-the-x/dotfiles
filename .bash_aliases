
##
 # The svn_repo() function returns the repository root URL of the provided
 # working copy, assuming "./" if omitted. This is useful for svn < 1.6.x,
 # which doesn't implement the "^/" shortcut for repository URLs.
##
svn_repo ( )
{
	svn info $1 | grep Root | sed -r 's/^.*: //'
} ## END svn_repo

if [ !`which editor` ]; then
    export EDITOR=`which vim`
fi
