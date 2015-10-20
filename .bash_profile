#!/bin/bash
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
source ~/.git-completion.bash
source ~/.bash_secrets.sh

desk="/Users/robertthomas/Desktop"
w="/Applications/XAMPP/xamppfiles/htdocs"

alias bx='bundle exec'
alias geminstall='gem install --no-document'
alias gito='git remote add origin '
alias gitrm='git rm --cached -r '
alias gl='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias iscripts='cd /Applications/Adobe\ Illustrator\ CS6/Presets.localized/en_US/Scripts'
alias openscad='cd /ZDocs/OPENSCAD/'
alias profile='vim ~/.bash_profile'
alias psql="'/Applications/Postgres.app/Contents/Versions/9.4/bin'/psql -p5432"
alias rdm='mv ./*.md ./readme.md'
alias reload='exec bash -l'
alias remigrate='rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed'
alias rspec='rspec -f d'
alias rubz='cd ~/Programming/ruby'
alias vimrc='vim ~/.vimrc'
alias pyserv='python -m SimpleHTTPServer'

useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1 # display the unstaged (*) and staged (+) indicators

function only(){
  rm -rf !($1)
}

function l(){
  echo ""
  echo "----------"
  ls -AF1
  echo "----------"
  echo ""
}

function search(){
  grep -nrilS $1 .
}

function happ(){
  for app in $(heroku apps)
    do heroku apps:destroy --app $app --confirm $app
  done
}

function chrome(){
  REGEX='s/[a-zA-Z\/]*htdocs\///g'
  PWD=$(echo "$(pwd)" | sed -e $REGEX)
  if [[ $(pwd) != *"htdocs"* ]]
  then
    open -a Google\ Chrome.app "file:///$(pwd)/$1"
  elif [ -n "$1" ] && [ -f $1 ]
  then
    open -a Google\ Chrome.app "http://localhost/$PWD/$1"
  else
    open -a Google\ Chrome.app "http://localhost/index.php?url=./$PWD"
  fi
}

function html(){
  cp -pR $w/lib/default_html $1
  cd $1
  git init
  chrome index.html
  vim index.html
}

function letter(){
  FILENAME="$(date +%y%m%d)_$1.html"
  cp $w/lib/letter.html "$w/letters/$FILENAME"
  cd $w/letters
  chrome $FILENAME
  vim $FILENAME
}

function nougat(){
  # Because it's like "new git"
  # $1 is "ga" or "me
  # $2 is name
  # $3 is description
  url="https://api.github.com/"
  if [ "$1" == "ga" ]; then
    url+="orgs/ga-dc"
    acct="ga-dc"
  elif [ "$1" == "me" ]; then
    url+="user"
    acct="robertakarobin"
  else
    echo "Indicate 'me' or 'ga', dummy."
    return
  fi
  url+="/repos"
  params='{"name":"'$2'", "description":"'$3'"}'
  curl -vvvv --include --user robertakarobin:"$GH_ACCESS" -A "$useragent" "$url" -d "$params"
  git init
  git remote add origin "git@github.com:$acct/$2.git"
}

function cleardb(){
  tfile="db_drops.txt"
  touch ~/$tfile
  psql -o ~/$tfile << EOF
    SELECT datname FROM pg_database WHERE datname NOT IN ('$(whoami)','postgres') AND datistemplate = false;
EOF
  n=0
  tot=$(wc -l < ~/$tfile)
  while read line
  do
    n=$(($n + 1))
    if [[ $n -gt 2 && $n -lt $(($tot - 1)) ]]; then
      echo "dropdb" $line
      dropdb $line
    fi
  done < ~/$tfile
  rm ~/$tfile
}

function gh(){
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" == "" ]
    then
     echo "Not a git repository or no remote.origin.url set"
     exit 1;
  fi

  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/\.git}
  open $giturl
}

function gitsearch(){
  git rev-list --all | xargs git grep -i $1
}

function rename_tree(){
  for i in $(find . -name "$1"); do mv $i "$(dirname $i)/$2"; done
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PS1="\W\$(__git_ps1)$ "
