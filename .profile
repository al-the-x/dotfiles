# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

LOCAL_PATHS="/usr/local /opt/local $HOME"

for LOCAL_PATH in $LOCAL_PATHS; do
    # set PATH so it includes $LOCAL_PATH/bin, if it exists
    if [ -d "$LOCAL_PATH/bin" ]; then
        PATH="$LOCAL_PATH/bin:$PATH"
    fi

    # set MANPATH so it includes $LOCAL_PATH/share/man, if it exists
    if [ -d "$LOCAL_PATH/share/man" ]; then
        MANPATH="$LOCAL_PATH/share/man:$MAN_PATH"
    fi
done

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

