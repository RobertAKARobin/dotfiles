[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
source ~/.git-completion.bash

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

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1 # display the unstaged (*) and staged (+) indicators

l(){
  echo ""
  echo "----------"
  ls -AF1
  echo "----------"
  echo ""
}

search(){
  grep -nrilS $1 .
}

happ(){
  for app in $(heroku apps)
    do heroku apps:destroy --app $app --confirm $app
  done
}

gitmorning(){
  webz
  cd ga
  cd half2
  git checkout master
  git pull
}

chrome(){
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

html(){
  cp -pR $w/lib/default_html $1
  cd $1
  git init
  chrome index.html
  vim index.html
}

letter(){
  FILENAME="$(date +%y%m%d)_$1.html"
  cp $w/lib/letter.html "$w/letters/$FILENAME"
  cd $w/letters
  chrome $FILENAME
  vim $FILENAME
}

gh(){
  mv starter/* .
  rmdir starter
  mv ./*.md ./readme.md
  params='{"name":"'$1'", "description":"'$2'"}'
  curl --user 'robertakarobin:$GH_PASSWORD' -d "$params" https://api.github.com/orgs/ga-dc/repos
  git init
  git add .
  git rm -r --cached solution
  git commit -m "Initial commit"
  git checkout -b solution
  rm -rf !(solution)
  mv solution/* .
  rmdir solution
  mv ./*.md ./readme.md
  git add .
  git commit -m "Added solution"
  git remote add origin "git@github.com:ga-dc/$1.git"
  git push origin master
  git push origin solution
}

cleardb(){
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

only(){
  rm -rf !($1)
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PS1="\W\$(__git_ps1)$ "
