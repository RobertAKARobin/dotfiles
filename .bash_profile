#!/bin/bash

# Homebrew
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
if type brew &>/dev/null; then
	eval "$(/opt/homebrew/bin/brew shellenv)"

	HOMEBREW_PREFIX="$(brew --prefix)"
	if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	else
		for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
			[[ -r "$COMPLETION" ]] && source "$COMPLETION"
		done
	fi

	# OpenSSL
	export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
	export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
	export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
fi

check_bash_version() {
	local version=$(echo $BASH_VERSION | head -c 1)
	if [[ $version -lt 5 ]]; then
		echo "Bash version is too low at $version; installing latest Bash..."
		brew install bash
		local bash_location="/opt/homebrew/bin/bash"
		echo $bash_location | sudo tee -a /etc/shells
		chsh -s $bash_location
		sudo chsh -s $bash_location
		echo "Restart the terminal"
	fi
}
check_bash_version

shopt -s globstar # https://stackoverflow.com/a/78041926/2053389

source ~/.bash_profile_helpers
if [ -f ~/.bash_profile_private ]; then
	source ~/.bash_profile_private
fi

# Git
if [ -z "$BASH_COLOR" ]; then
	BASH_COLOR="\e[33m"
fi
export PS1="\[$BASH_COLOR\]  \d \t \w\$(git_branch)"$'\n\[\e[m\]\\$ '

# Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"	# This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"	# This loads nvm bash_completion
if command -v fnm &> /dev/null; then
	eval "$(fnm env --use-on-cd)"
fi

# Deno
export PATH="$HOME/.deno/bin:$PATH"
export DVM_DIR="$HOME/.dvm"
export PATH="$DVM_DIR/bin:$PATH"

# Python pyenv
if command -v pyenv 1>/dev/null 2>&1; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"

	# Google Cloud
	export CLOUDSDK_PYTHON="$HOME/.pyenv/shims/python"
fi

# Python pipenv
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_IGNORE_VIRTUALENVS=1

# Ruby
if command -v rbenv &> /dev/null; then
	eval "$(rbenv init -)"
fi

# Misc
export BASH_SILENCE_DEPRECATION_WARNING=1

# Google Cloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/google-cloud-sdk/path.bash.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/google-cloud-sdk/completion.bash.inc"; fi

# K40 Whisperer
# https://github.com/rsre/K40-Whisperer-macOS
# NOTE: LDFLAGS and CPPFLAGS conflict with `rbenv install`
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
# export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
# export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk/lib/pkgconfig"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"
if command -v rust &> /dev/null; then
	source "$HOME/.cargo/env"
fi
