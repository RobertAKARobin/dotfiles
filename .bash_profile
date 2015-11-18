#!/bin/bash

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=1
  prompt='$(__git_ps1)'
fi
PS1="\W$prompt\n\$ "

alias profilel="vim ~/.bash_profile_local"
source ~/.bash_profile_local

alias geminstall='gem install --no-document'
alias gitrm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias profile='vim ~/.bash_profile'
alias reload='exec bash -l'
alias remigrate='rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed'
alias vimrc='vim ~/.vimrc'
alias pyserv='python -m SimpleHTTPServer'
alias vinstall='git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
alias vupdate='vim +PluginInstall +qall'

useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36"

function sship(){
  user=$1
  tunnel=$2
  cmd="ssh $user@$droplet"
  if [ $tunnel ]
    then cmd="$cmd -R localhost:2000:localhost:22"
  fi
  eval $cmd
}

function gitssh(){
  git push -f origin master
  ssh $(whoami)@$droplet "( cd /var/www/$(basename $PWD) && git fetch origin master && git reset --hard FETCH_HEAD && git clean -df )"
}

function ls-a(){
  echo ""
  echo "----------"
  ls -AF1 $1
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

function ghkey(){
  email=$1
  if [ "$email" == "" ]
    then
    echo "Include an e-mail address!"
    kill -INT $$
  fi
  if [ -e ~/.ssh/id_rsa ]
    then
    echo "id_rsa already exists!"
    kill -INT $$
  fi
  ssh-keygen -t rsa -b 4096 -C "$email"
  ssh-add ~/.ssh/id_rsa
  cat ~/.ssh/id_rsa.pub | pbcopy
}

