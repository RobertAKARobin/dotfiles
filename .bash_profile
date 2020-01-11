#!/bin/bash

source ~/.bash_profile_helpers
if [ -f ~/.bash_profile_private ]; then 
  source ~/.bash_profile_private
fi

export PATH="/usr/local/sbin:$PATH" 

# Git
if [ -z "$BASH_COLOR" ]; then
  BASH_COLOR="\e[33m"
fi
export PS1="\[$BASH_COLOR\]  \d \t \w\$(git_branch)"$'\n\[\e[m\]\\$ '

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PATH="$PATH:/Users/$(whoami)/.local/bin"

# Ruby
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

source ~/Library/Preferences/org.dystroy.broot/launcher/bash/br
export MACPREFS_BACKUP_DIR="$HOME/Google Drive/Backup/Macprefs"

export BASH_SILENCE_DEPRECATION_WARNING=1
