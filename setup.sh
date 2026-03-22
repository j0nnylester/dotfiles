#!/bin/bash

set -e

dir=$(cd "$(dirname "$0")" || exit; pwd)
folders=$(find "$dir" -maxdepth 1 -type d -name "[!.]*")

if [ "$(uname -s)" == "Darwin" ]; then
  sedFlags="sed -i -e"
else
  sedFlags="sed -i"
fi

for fold in ${folders}
  do
  files=$(find "$fold" -maxdepth 1 -type f -not -name "gituser" -not -name "git-ff")
  for file in ${files}
    do
      filename=$(basename "$file")
      (if [ -L "$HOME/.$filename" ]; then
        rm "$HOME/.$filename"
      elif [ -f "$HOME/.$filename" ]; then
        cp "$HOME/.$filename" "$HOME/.$filename.$(date '+%Y%m%d').bak"
      else
        :
      fi)

      ln -s "$file" "$HOME/.$filename"
    done
  done

if [ ! -f "$HOME/.gituser" ]; then
  cp "$dir/git/gituser" "$HOME/.gituser"
fi

if grep -q _DOTFILES_ "$HOME/.gituser"; then
  $sedFlags "s|_DOTFILES_|$dir|g" "$HOME/.gituser"
fi

if tty -s
then
  name=$(grep 'name =' "$HOME/.gituser" | awk -F'"' '{ print $2 }')
  if [ "$name" == "_NAME_" ]; then
   read -rp "your name [default=${name}] " name_answer
  : "${name_answer:=$name}"
    if [ "$name_answer" != "$name" ]; then
      $sedFlags "s/$name/$name_answer/g" "$HOME/.gituser"
    fi
  fi
 
  email=$(grep 'email =' "$HOME/.gituser" | awk -F'"' '{ print $2 }')
  if [ "$email" == "_EMAIL_" ]; then
    read -rp "your email [default=${email}] " email_answer
    : "${email_answer:=$email}"
    if [ "$email_answer" != "$email" ]; then
      $sedFlags "s/$email/$email_answer/g" "$HOME/.gituser"
    fi
  fi
fi

curl -sLo "$HOME/.git-completion.bash" https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
curl -sLo "$HOME/.git-prompt.bash" https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
