#!/bin/bash

source ~/.bash_profile_local
source ~/.bash_profile_helpers

export PS1="\[\e[33m\]  \d \t \w\$(git_branch)"$'\n\[\e[m\]\\$ '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JAVA_HOME="$(/usr/libexec/java_home -v 10.0.2)"

# This has to be at the end of the file
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
