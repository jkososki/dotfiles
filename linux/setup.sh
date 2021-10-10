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

function dotfiles {
   sudo -H -u $uname /usr/bin/git --git-dir=$dot_dir/ --work-tree=$home_dir $@
}

bkdir="$home_dir/.dotfiles-backup/$(date +%s)"

if [ -d "$dot_dir" ]
then
    dotfiles pull 
else
    echo $dot_dir
    sudo -u $uname git clone --bare -b linux git@github.com:jkososki/dotfiles.git $dot_dir

    dotfiles checkout
    if [ $? > 0 ]; then
      echo "Backing up pre-existing dot files.";

      sudo -H -u $uname mkdir -p $bkdir 

      dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} sudo -H -u $uname mv $home_dir/{} $bkdir/{}
      dotfiles checkout

    fi;
fi

dotfiles config status.showUntrackedFiles no

apt-get update && apt-get install -y zsh

chsh $uname -s $(which zsh)
echo "Set default shell to $(which zsh)"
echo ""

omz="$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo -H -u $uname sh -c $omz "" --unattended --keep-zshrc

pl_dir="$home_dir/.oh-my-zsh/custom/themes/powerlevel10k" 
if [ -d "$home_dir" ]
then
    echo "Updating powerlevel10k..."
    sudo -H -u $uname /usr/bin/git --work-tree=${pl_dir} pull
else
    pl_repo="https://github.com/romkatv/powerlevel10k.git" 
    sudo -H -u $uname git clone --depth=1 $pl_repo $pl_dir 
fi;
