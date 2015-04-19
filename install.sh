#!/usr/bin/env bash

# A script to install my development environments.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

##
# install some base packages
##
command -v pacman >/dev/null 2>&1 && {
    # In case this is an archlinux installation
    sudo pacman -S zsh ack tmux htop wget curl vim tree elinks
}
command -v apt-get >/dev/null 2>&1 && {
    # In case this is a debian installation
    sudo apt-get install zsh ack-grep tmux htop wget curl vim-nox tree elinks
}


##
# zsh configuration
##

# Install oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# Install zsh configuration
rm -rf ~/.zshrc ~/.zshrc.d > /dev/null 2>&1
ln -s ${DIR}/zsh/zshrc ~/.zshrc
ln -s ${DIR}/zsh/zshrc.d ~/.zshrc.d


##
# vim configuration
##

# Install vim configuration files
[[ -L ~/.vimrc ]] || {
    rm -rf ~/.vimrc > /dev/null 2>&1 ;
    ln -s ${DIR}/vim/vimrc ~/.vimrc
}
[[ -L ~/.vim ]] || {
    rm -rf ~/.vim > /dev/null 2>&1
    ln -s ${DIR}/vim/vim ~/.vim
}

# install Vundle if not already installed
[[ -d ~/.vim/bundle/Vundle.vim ]] || git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# Install vundle dependencies
vim +PluginInstall +qall

[[ ! -d ~/.vim/bundle/command-t/ ]] || {
    # Install command-t
    # Compilation is required
    cd ~/.vim/bundle/command-t/ruby/command-t
    ruby extconf.rb
    make
    cd $DIR
}
[[ -f /usr/share/fonts/misc/PowerlineSymbols.otf ]] || {
    # Install vim-airline/vim-powerline font
    sudo wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O /usr/share/fonts/misc/PowerlineSymbols.otf
    fc-cache -vf ~/.fonts/
    mkdir -p ~/.config/fontconfig/conf.d/
    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
}

##
# git configuration
##
echo -n "Would you like to configure your git name and email? (y/n) => "; read answer
if [[ $answer = "Y" ]] || [[ $answer = "y" ]]; then
    echo -n "What is your git user name => "; read name
    git config --global user.name "$name"
    echo -n "What is your git email => "; read email
    git config --global user.email "$email"
fi

echo "*******************************"
echo "*    Restart your terminal    *"
echo "*******************************"
