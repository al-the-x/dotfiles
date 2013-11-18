if [ -z "$(type -t __git_ps1)" ]; then
    function __git_ps1 ( ) { echo '[ XXX ]'; }
fi
