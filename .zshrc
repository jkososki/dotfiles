# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=10000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/lethe/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Import alias file
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

