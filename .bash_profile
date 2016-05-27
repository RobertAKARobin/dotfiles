#!/bin/bash

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=1
  git_prompt='$(__git_ps1)'
fi
export PS1="\[\e[33m\]  \d \t \w$git_prompt\n\[\e[m\]\\$ "
export EDITOR=/Applications/TextEdit.app/Contents/MacOS/TextEdit

alias geminstall='gem install --no-document'
alias gitrm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias profile='vim ~/.bash_profile'
alias profilel="vim ~/.bash_profile_local"
alias reload='source ~/.bash_profile'
alias remigrate='rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump && rake db:seed'
alias vimrc='vim ~/.vimrc'
alias pyserv='python -m SimpleHTTPServer'
alias timestamp='date "+%y-%m-%d_%H_%M_%S"'
alias vinstall='git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
alias vupdate='vim +PluginInstall +qall'
alias fo='git config core.filemode false'
alias py="python3"
alias own="sudo chmod -R 777"
alias sas="sass --style expanded --watch --sourcemap=none"
alias jad="jade -Pw"
alias jek="jekyll serve -w"
alias calc="echo 'Type \"bc\". Set decimal places with \"scale=n\"'"

useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36"

function gfix(){
  sha=$2
  if [ "$1" = "1" ]; then
    if [ -z "$sha" ]; then echo "Nope" && return 1; fi
    git add .
    git commit -m "wip"
    git checkout -b tmp
    git reset --hard "$sha"
    git reset --soft head~
  elif [ "$1" = "2" ]; then
    if [ -z "$sha" ]; then echo "Nope" && return 1; fi
    git commit -c ORIG_HEAD
    git cherry-pick "$sha"..master
  elif [ "$1" = "cp" ]; then
    git cherry-pick --continue
  elif [ "$1" = "3" ]; then
    git branch -D master
    git branch -m master
  fi
}

function sshot(){
  convert \
    -font         "LucidaSansTypewriterB" \
    -pointsize    "14" \
    -border       "10x10" \
    -extent       "600" \
    -bordercolor  "#000000" \
    -background   "#000000" \
    -fill         "#ffffaa" \
    label:@- "$1.png"
}

function gdi(){
  # outputl="$HOME/Desktop/$2.png"
  outputl="$w/ga/lessons/express-oauth-handrolled/images/$2"
  git diff --no-prefix head~ "$1" | tail -n +4 | $(sshot $outputl)
}

function gnext(){
  git log --reverse --pretty=%H master | grep -A 1 $(git rev-parse HEAD) | tail -n1 | xargs git checkout
}

function gprev(){
  git checkout head~
}

function gwat(){
  git diff head~
}

function copy(){
  cat $1 | pbcopy
}

function dumpdb(){
  pg_dump -Cc $1 -f ~/db_dumps/$1_$(timestamp).psql
}

function pup(){
  eval "sudo apachectl $1 && sudo httpd -k $1"
}

function chmodr(){
  find $1 \( -type f -execdir chmod 644 {} \; \) \
       -o \( -type d -execdir chmod 711 {} \; \)
}

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
  sudo grep -nrilS $1 .
}

function happ(){
  urlpfx='https://git.heroku.com/'
  urlsfx='.git'
  remote=$(git remote get-url heroku | sed "s~$urlpfx~~" | sed "s~$urlsfx~~")
  app=${1:-$remote}
  heroku apps:destroy --app $app --confirm $app
}

function happs(){
  while read app; do
    if [[  $app =~ ^[a-zA-Z0-9\-]+$ ]]; then
      happ $app
    fi
  done < <(heroku apps)
}

function cleardb(){
  tfile="db_drops.txt"
  rm ~/$tfile
  touch ~/$tfile
  psql -o ~/$tfile << EOF
    SELECT datname FROM pg_database WHERE datname NOT IN ('$(whoami)','postgres') AND datistemplate = false ORDER BY datname ASC;
EOF
  n=0
  tot=$(wc -l < ~/$tfile)
  for line in $(cat ~/$tfile); do
    n=$(($n + 1))
    if [[ $n -gt 2 && $n -lt $(($tot - 1)) ]]; then
      read -n1 -p "Drop database '$line'? [y/n] " dodrop
      echo ''
      if [ "$dodrop" = "y" ]; then
        dropdb $line
        echo "...dropped $line"
      fi
    fi
  done
}

function chrome(){
  APP="Google Chrome.app"
  if [[ $1 =~ ^http ]] ;
    then url=$1
  else
    url="http://localhost$(PWD)/$1"
  fi
  open -a "$APP" "$url"
}

function gh(){
  remote=${1:-origin}
  gitpfx='git@github.com:'
  urlpfx='https://www.github.com/'
  url=$(git remote get-url $remote | sed "s~$gitpfx~$urlpfx~" | sed "s~\.git\$~~")
  chrome $url
}

function gitsearch(){
  git rev-list --all | xargs git grep -i $1
}

function rename_tree(){
  for i in $(find . -name "$1"); do mv $i "$(dirname $i)/$2"; done
}

function ghkey(){
  email=$1
  if [ "$email" = "" ]
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

function mdhtml(){
  # brew install pandoc
  # brew install tidy-html5
  # brew install fswatch
  # mdhtml input.md output.html
  TITLE=$(basename "$PWD")
  CMD=" echo '===== Regenerating HTML...' \
        && pandoc $1 -f markdown -t html5 -s \
             --variable=pagetitle:'$TITLE' \
             --no-highlight \
        |  tidy -wrap 0 -indent -quiet -o $2"
  sh -c "$CMD"
  fswatch -0 $1 | xargs -0 -I % sh -c "$CMD"
}

export GITHUB_USERNAME='robertakarobin'

source ~/.rvm/scripts/rvm
source ~/.bash_profile_local

