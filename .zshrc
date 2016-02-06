######################
# zgen configuration #
######################
# use zgen plugin manager for zsh
# load zgen
source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    # load oh-my-zsh base
    zgen oh-my-zsh

    # load oh-my-zsh plugins
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/rsync
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/tmuxinator
    zgen oh-my-zsh plugins/ubuntu
    
    # do not use plugins/autojump if exists local install autojump
    [[ ! -s ~/.autojump/etc/profile.d/autojump.sh ]] && zgen oh-my-zsh plugins/autojump
    
    # external plugins
    zgen load zsh-users/zsh-syntax-highlighting

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load NoAnyLove/dotfiles zsh/themes/custom-ys
    
    # save all to init script
    zgen save
fi

# alias
alias ls='ls --color=auto'
alias l='ls -CF'
alias la='ls -AF'
alias ll='ls -lhF'
alias lla='ls -lahF'

# source local install autojump
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && source ~/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

# source thefuck
[[ -n $commands[thefuck] ]] && eval $(thefuck --alias)

# Override plugin ubuntu
alias ac='sudo apt-cache'
#alias ag='sudo apt-get'
alias app='sudo apt-cache show'

# this fix Ctrl-s shortcut for vim-ipython
stty stop undef # to unmap ctrl-s

# bindkey for PuTTY Ctrl+LeftArrow and Ctrl+RightArrow
bindkey '^[[C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

# bindkey for Home/End keys
bindkey '^[[1~' beginning-of-line           # [Home] - move to the beginning of line
bindkey '^[[4~' end-of-line                 # [End] - move to the end of line

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-solarized.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# export EDITOR
export EDITOR=vim