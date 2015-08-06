[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

alias vimrc="vim ~/.vimrc"
alias profile="vim ~/.bash_profile"
alias desk="cd ~/Desktop"
alias reload="exec bash -l"
alias gl='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias rspec='rspec -f d'
alias geminstall='gem install --no-document'
alias bx='bundle exec'
alias gito='git remote add origin '
alias gitrm='git rm --cached -r '
alias rdm='mv ./*.md ./readme.md'
alias remigrate='rake db:drop && rake db:create && rake db:migrate && rake db:schema:dump'

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

###
###
###

source ~/.git-completion.bash

w="/Applications/XAMPP/xamppfiles/htdocs"

alias psql="'/Applications/Postgres.app/Contents/Versions/9.4/bin'/psql -p5432"
alias rubz="cd ~/Programming/ruby"
alias iscripts='cd /Applications/Adobe\ Illustrator\ CS6/Presets.localized/en_US/Scripts'
alias openscad='cd /ZDocs/OPENSCAD/'

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

gh(){
  mv starter/* .
  rmdir starter
  mv ./*.md ./readme.md
  params='{"name":"'$1'", "description":"'$2'"}'
  curl --user 'robertakarobin:$GH_PASSWORD!' -d "$params" https://api.github.com/orgs/ga-dc/repos
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

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PS1="\W $ "
