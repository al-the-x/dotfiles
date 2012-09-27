#!/bin/bash

if [[ -z $(which git) ]]; then
    echo 'Is git installed yet?' 1>&2
    exit 1
fi

GIT="$(which git) --git-dir=$HOME/.git --work-tree=$HOME"
GITHUB="git@github.com:al-the-x/Bash_Profiles.git"

(   $GIT init &&
    $GIT remote add origin $GITHUB &&
    $GIT remote show origin &&
    $GIT pull origin master &&
    $GIT submodule update --init
)

