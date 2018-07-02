#!/bin/bash

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=1
  git_prompt='$(__git_ps1)'
fi
export PS1="\[\e[33m\]  \d \t \w$git_prompt\n\[\e[m\]\\$ "

eval $(/usr/libexec/path_helper -s)
source ~/.bash_profile_local
source ~/.bash_profile_helpers

# This has to be at the end of the file
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
