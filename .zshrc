######################
# zgen configuration #
######################
# use zgen plugin manager for zsh

if [ ! -f ~/.zgen/zgen.zsh ]; then
    echo "Install zgen"
    git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# disable oh-my-zsh auto update
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

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

    # change defualt ANSI colors
    zgen load chriskempson/base16-shell

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

# unalias ag for apt-get, save it for silversearcher-ag
unalias ag
alias app='sudo apt-cache show'

# bindkey for PuTTY Ctrl+LeftArrow and Ctrl+RightArrow
bindkey '^[[C' forward-word                        # [Ctrl-RightArrow] - move forward one word
bindkey '^[[D' backward-word                       # [Ctrl-LeftArrow] - move backward one word

# bindkey for Home/End keys
bindkey '^[[1~' beginning-of-line           # [Home] - move to the beginning of line
bindkey '^[[4~' end-of-line                 # [End] - move to the end of line

# Base16 Shell
BASE16_THEME="default-dark"
BASE16_SHELL="$HOME/.zgen/chriskempson/base16-shell-master/scripts/base16-$BASE16_THEME.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# BASE16_SHELL=$HOME/.zgen/chriskempson/base16-shell-master/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# export EDITOR
export EDITOR=vim

# load local customization script
[[ -s ~/.config/myzsh.zsh ]] && source ~/.config/myzsh.zsh

function update_dotfiles() {
    if [ -z $1 ]; then
        print "Update dotfiles"
        if [ ! -d ~/.config ]; then
            print "Create ~/.config folder"
            mkdir ~/.config
        fi
        
        # update zsh config
        cp -v ~/.zgen/NoAnyLove/dotfiles-master/.zshrc ~/
        # update tmux config
        cp -v ~/.zgen/NoAnyLove/dotfiles-master/.tmux.conf ~/
        cp -v ~/.zgen/NoAnyLove/dotfiles-master/.config/tmux ~/.config/tmux -R
        # update vrapperrc config
        cp -v ~/.zgen/NoAnyLove/dotfiles-master/.vrapperrc ~/
        print "Update finished"
    else
        case $1 in
        minimal)
            print "Update minimal Vim configuration"
            cp -v ~/.zgen/NoAnyLove/dotfiles-master/.vimrc.minimal ~/.vimrc
            ;;
        vim)
            print "Update basic Vim configuration"
            cp -v ~/.zgen/NoAnyLove/dotfiles-master/.vimrc ~/.vimrc
            ;;
        *)
            print "Unknown Parameter $1"
        esac
    fi
}
