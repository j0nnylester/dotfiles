#!/bin/bash

# Copy or Link files
## ignore readme and setup files
dir=$(dirname $0)
folders=$(ls $dir | grep -vE '.git|.github|setup')

for fold in ${folders}
  do
  files=$(ls $dir/$fold | grep -vE 'gituser|git-ff')
  for file in ${files}
    do
      if [ -f ~/.$file ] && [ -L ~/.$file ]; then 
        rm ~/.$file
      else
        cp ~/.$file ~/.$file.$(date '+%Y%m%d').bak;
      fi

      ln -s $dir/$fold/$file ~/.$file
    done
  done

if [ ! -f ~/.gituser ]; then
  cp git/gituser ~/.gituser
fi


# Edit .gituser in place
name=$(grep 'name =' ~/.gituser | awk -F'"' '{ print $2 }')
read -p "your name [default=$name] " name_answer
: ${name_answer:=$name}

email=$(grep 'email =' ~/.gituser | awk -F'"' '{ print $2 }')
read -p "your email [default=$email] " email_answer
: ${email_answer:=$email}

if [ "$name_answer" != "$name" ];
then
  sed -i "s/\"$name\"/\"$name_answer\"/g" ~/.gituser
fi

if [ "$email_answer" != "$email" ];
then
  sed -i "s/\"$email\"/\"$email_answer\"/g" ~/.gituser
fi

# download git completion
curl -sLo ~/.git-completion.bash https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
curl -sLo ~/.git-prompt.bash https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh

# add vim-plug
curl -sfLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim