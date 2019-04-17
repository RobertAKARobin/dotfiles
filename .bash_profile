#!/bin/bash

source ~/.bash_profile_helpers
if [ -f ~/.bash_profile_private ]; then 
  source ~/.bash_profile_private
fi

export PATH="/usr/local/sbin:$PATH" 

# Git
export GITHUB_USERNAME='robertakarobin'
export PS1="\[\e[33m\]  \d \t \w\$(git_branch)"$'\n\[\e[m\]\\$ '

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
# if command -v virtualenv 1>/dev/null 2>&1; then
#   export WORKON_HOME=$HOME/.virtualenvs
#   source /usr/local/bin/virtualenvwrapper.sh
#   export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
# fi

# Ruby
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi
