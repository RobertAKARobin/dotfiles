#!/bin/bash

source ~/.bash_profile_local
source ~/.bash_profile_helpers

export PS1="\[\e[33m\]  \d \t \w\$(git_branch)\n\[\e[m\]\\$ "

# This has to be at the end of the file
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
