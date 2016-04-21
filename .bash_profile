#!/bin/bash

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
  GIT_PS1_SHOWDIRTYSTATE=1
  prompt='$(__git_ps1)'
fi
PS1="\w$prompt\n\$ "

alias profilel="vim ~/.bash_profile_local"
source ~/.bash_profile_local
source ~/.rvm/scripts/rvm

alias geminstall='gem install --no-document'
alias gitrm='git rm --cached -r '
alias gl='git log --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias gla='git log --all --decorate --graph --pretty=format:"%C(yellow)%h%Creset %C(auto)%d%Creset %Cblue%ar%Creset %Cred%an%Creset %n%w(72,1,2)%s"'
alias profile='vim ~/.bash_profile'
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

# 1. $ brew install imagemagick
# 2. Make system fonts available to imagemagick
#   - $ curl http://www.imagemagick.org/Usage/scripts/imagick_type_gen > imagick_find_fonts.sh
#   - $ perl imagick_find_fonts.sh > type.xml
#   - $ mv type.xml /usr/local/Cellar/imagemagick/some-version-number/etc/ImageMagick-6/
#   - $ convert -list font
# 3. $ echo "foo" | sshot ~/Desktop/myfile
# 4. Image of "foo" is saved to Desktop as myfile.png
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

# 1. gdi path-to-file.html name-of-image
# 2. Image is saved as name-of-image.png
function gdi(){
  # outputl="$HOME/Desktop/$2.png"
  outputl="$w/ga/lessons/express-oauth-handrolled/images/$2"
  git diff --no-prefix head~ "$1" | tail -n +4 | $(sshot $outputl)
}

# Loops through repo's entire Git history, and for each commit,
# loops through all files changed in that commit, and makes a
# screenshot of that file's diff.
# See steps 1 and 2 of #sshot above
function gdis(){
  folder="diff_imgs"
  rm -rf $folder
  mkdir $folder

  # Preserves whitespace. ¯\_(ツ)_/¯
  IFS='%'
  # Removes the first commit since you can't diff it
  # Prints SHA on one line and commit message on another because hard to "split"
  commits=$(git log --pretty=format:"%h%n%s" | tail -r | tail -n +2 | tail -r)
  commitnum=1
  linenum=0
  while read commitline; do
    commitnum=$(($linenum / 2))
    if (( $linenum % 2 == 0 )); then
      hash="$commitline"
    else
      # Removes non-alphanumeric characters from commit message, downcases, adds dashes
      message=$(echo $commitline | tr "[:upper:]" "[:lower:]" | sed \
        -e "s/[^a-zA-Z0-9 \-]//g" \
        -e "s/ /-/g" \
        -e "s/-\{2,\}/-/g")
      # A = added, M = modified, R = removed
      diffiles=$(git diff --diff-filter=AMR --name-only "$hash~..$hash")
      echo "$hash: $commitline"
      while read filepath; do
        echo "    $filepath"
        # Removes non-alphanumeric characters from filename, adds dashes
        fileabbr=$(echo $filepath | sed \
          -e "s/[^a-zA-Z0-9]/-/g" \
          -e "s/-\{2,\}/-/g")
        imageout="$message.$fileabbr.png"
        printcmd=$(cat <<heredoc
convert \
-font         "Consolas" \
-pointsize    "16" \
-extent       "800" \
-quality      "0" \
-bordercolor  "#000000" \
-background   "#000000" \
-gravity      "SouthWest"
heredoc)
        # First row of each image is the SHA and commit message
        printcmd+=" -fill \"#ffffff\" label:\"$hash: $commitline \""
        # 
        diff="$(git diff --no-prefix "$hash~..$hash" -- $filepath | tail -n +4)"
        while read diffline; do
          # If line begins with @@ or ---
          if [[ "$diffline" =~ ^(@@|---) ]]; then
            color="#aaaaaa"
          # If line begins with -
          elif [[ "$diffline" =~ ^-{1}([^-]|$) ]]; then
            color="#ff0000"
          # If line begins with +
          elif [[ "$diffline" =~ ^\+{1}([^\+]|$) ]]; then
            color="#00ff00"
          else
            color="#ffffff"
          fi
          # %q escapes quotes
          diffline=$(printf "%q" "$diffline")
          # Adds 20px to end of image and fills it with text
          printcmd+=" -splice 0x20 -fill \"$color\" -annotate 0 \" $diffline\""
        done <<< "$diff"
        # End with a blank line
        printcmd+=" -splice 0x20 -annotate 0 \" \""
        # Print to this filename
        printcmd+=" \"./diff_imgs/$imageout\""
        eval $printcmd
      done <<< "$diffiles"
    fi
    let "linenum += 1"
  done <<< "$commits"
  unset IFS
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
  for app in $(heroku apps)
    do heroku apps:destroy --app $app --confirm $app
  done
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

function gh(){
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" = "" ]
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

export GITHUB_USERNAME='robertakarobin'
