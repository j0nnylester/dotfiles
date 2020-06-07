#!/bin/bash

dir=$(cd "$(dirname "$0")"; pwd)
folders=$(ls $dir | grep -vE '\.sh$')

for fold in ${folders}
  do
  files=$(ls $dir/$fold | grep -vE 'gituser|git-ff')
  for file in ${files}
    do
      (if [ -L "$HOME/.$file" ]; then 
        rm "$HOME/.$file"
      elif [ -f "$HOME/.$file" ]; then
        cp $HOME/.$file $HOME/.$file.$(date '+%Y%m%d').bak
      else
        :
      fi)

      ln -s $dir/$fold/$file $HOME/.$file
    done
  done

if [ ! -f "$HOME/.gituser" ]; then
  cp $dir/git/gituser $HOME/.gituser
fi

if [[ -n $(grep _DOTFILES_ $HOME/.gituser) ]]; then
  sed -i "s|_DOTFILES_|$dir|g" $HOME/.gituser
fi

if tty -s
then
  name=$(grep 'name =' "$HOME/.gituser" | awk -F'"' '{ print $2 }')
  if [ "$name" == "_NAME_" ]; then
   read -p "your name [default=$name] " name_answer
  : ${name_answer:=$name}
    if [ "$name_answer" != "$name" ]; then
      sed -i "s/\"$name\"/\"$name_answer\"/g" $HOME/.gituser
    fi
  fi
 
  email=$(grep 'email =' "$HOME/.gituser" | awk -F'"' '{ print $2 }')
  if [ "$email" == "_EMAIL_" ]; then
    read -p "your email [default=$email] " email_answer
    : ${email_answer:=$email}
    if [ "$email_answer" != "$email" ]; then
      sed -i "s/\"$email\"/\"$email_answer\"/g" $HOME/.gituser
    fi
  fi
fi

curl -sLo "$HOME/.git-completion.bash" https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
curl -sLo "$HOME/.git-prompt.bash" https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh
curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim