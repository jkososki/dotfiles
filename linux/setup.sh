#!/bin/bash

git clone --bare -b linux git@github.com:jkososki/dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

bkdir="$HOME/.dotfiles-backup-$(date +%s)"
mkdir -p $bkdir 

dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $bkdir/{}
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no

apt-get update && apt-get install zsh

chsh -s $(which zsh)
