# Install

## Install prerequisite

```
sudo apt-get install python git
sudo apt-get install vim htop tmux

# install pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
```

## Install fonts

I personally like Fantasque Sans Mono

```
https://github.com/belluzj/fantasque-sans
```

## Install autojump

```
git clone https://github.com/wting/autojump.git
cd autojump
# 如果有root权限就使用系统全局安装，所有用户都可以使用。oh-my-zsh的autojump插件只引用全局安装的autojump
sudo install.py --system
```

## Install command-not-found

```
sudo apt-get install command-not-found
sudo update-command-not-found
```

## Install thefuck

```
sudo pip install thefuck
```

## Install Vim

如果Vim版本低于7.4，需要编译安装最新版。

## Install Vim-Plug

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```