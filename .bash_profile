#!/bin/bash

source ~/.bash_profile_helpers
if [ -f ~/.bash_profile_private ]; then 
  source ~/.bash_profile_private
fi

# Homebrew
export PATH="/usr/local/sbin:$PATH" 
export PATH="/opt/homebrew/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# Git
if [ -z "$BASH_COLOR" ]; then
  BASH_COLOR="\e[33m"
fi
export PS1="\[$BASH_COLOR\]  \d \t \w\$(git_branch)"$'\n\[\e[m\]\\$ '

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Deno
export PATH="/Users/$(whoami)/.deno/bin:$PATH"

# Python pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  export CLOUDSDK_PYTHON=/Users/$(whoami)/.pyenv/shims/python
fi

# Python pipenv
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_IGNORE_VIRTUALENVS=1

# Ruby
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
fi

# Misc
export BASH_SILENCE_DEPRECATION_WARNING=1

# Google Cloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f "/Users/$(whoami)/google-cloud-sdk/path.bash.inc" ]; then . "/Users/$(whoami)/google-cloud-sdk/path.bash.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "/Users/$(whoami)/google-cloud-sdk/completion.bash.inc" ]; then . "/Users/$(whoami)/google-cloud-sdk/completion.bash.inc"; fi

# K40 Whisperer
# https://github.com/rsre/K40-Whisperer-macOS
# NOTE: LDFLAGS and CPPFLAGS conflict with `rbenv install`
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
# export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
# export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"

# Rust
if command -v rust &> /dev/null; then
  source "$HOME/.cargo/env"
fi
