#!/bin/bash

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    uname=$SUDO_USER
else
    uname=$(whoami)
fi

home_dir=$(eval echo ~$uname)
dot_dir=$home_dir/.dotfiles

sudo -u $uname git clone --bare -b linux git@github.com:jkososki/dotfiles.git $dot_dir

function dotfiles {
   sudo -H -u $uname /usr/bin/git --git-dir=$dot_dir/ --work-tree=$home_dir $@
}

bkdir="$home_dir/.dotfiles-backup-$(date +%s)"
sudo -H -u $uname mkdir -p $bkdir 

dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} sudo -H -u $uname mv $home_dir/{} $bkdir/{}
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no

apt-get update && apt-get install -y zsh

chsh $uname -s $(which zsh)
echo "Set default shell to $(which zsh)"

zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
