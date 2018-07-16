#!/bin/bash

source ~/.bash_profile_local
source ~/.bash_profile_helpers

export PS1="\e[0;33m\n\w\$(git_branch) $\e[0m "

# This has to be at the end of the file
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
