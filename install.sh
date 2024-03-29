#!/usr/bin/env bash

# A script to install my development environments.

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

##
# Install brew if needed
##
[ "$(uname -s)" == "Darwin" ] && [ ! -f '/opt/homebrew/bin/brew' ] && {
    (/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" && eval "$(/opt/homebrew/bin/brew shellenv)")
}

##
# install some base packages
##
command -v pacman >/dev/null 2>&1 && {
    # In case this is an archlinux installation
    sudo pacman -S zsh ack tmux htop wget curl vim tree elinks fzf highlight
}
command -v apt-get >/dev/null 2>&1 && {
    # In case this is a debian installation
    sudo apt-get install zsh ack-grep tmux htop wget curl vim-nox tree elinks
}

command -v brew >/dev/null 2>&1 && {
    # In case this is a debian installation
    brew install rg tmux htop fzf vim tree tig
    # Install PowerlineSymbols
    brew tap homebrew/cask-fonts
    brew install --cask font-dejavu font-dejavu-sans-mono-for-powerline font-dejavu-sans-mono-nerd-font
}

##
# sh configuration, common for bash and zsh
##

# Install sh commons
rm -rf ~/.shrc ~/.shrc.d > /dev/null 2>&1
ln -s ${DIR}/sh/shrc ~/.shrc
ln -s ${DIR}/sh/shrc.d ~/.shrc.d

# Install bash configuration
rm -rf ~/.bashrc ~/.bashrc.d ~/.bashrc-pre.d > /dev/null 2>&1
ln -s ${DIR}/bash/bashrc ~/.bashrc
ln -s ${DIR}/bash/bashrc.d ~/.bashrc.d
ln -s ${DIR}/bash/bashrc-pre.d ~/.bashrc-pre.d

##
# zsh configuration
##

# Install oh-my-zsh
[[ -d ~/.oh-my-zsh ]] || curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# Install zsh configuration
rm -rf ~/.zshrc ~/.zshrc.d ~/.zsh-custom ~/.zshrc-pre.d > /dev/null 2>&1
ln -s ${DIR}/zsh/zshrc ~/.zshrc
ln -s ${DIR}/zsh/zshrc.d ~/.zshrc.d
ln -s ${DIR}/zsh/zshrc-pre.d ~/.zshrc-pre.d
ln -s ${DIR}/zsh/zsh-custom ~/.zsh-custom


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
# Install Coc.nvim extensions
vim -c 'CocInstall -sync coc-json coc-html coc-git coc-prettier coc-tsserver coc-css|q'

#[[ ! -d ~/.vim/bundle/command-t/ ]] || {
#    # Install command-t
#    # Compilation is required
#    cd ~/.vim/bundle/command-t/ruby/command-t
#    ruby extconf.rb
#    make
#    cd $DIR
#}
#[[ -f /usr/share/fonts/misc/PowerlineSymbols.otf ]] || {
#    # Install vim-airline/vim-powerline font
#    sudo wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf -O /usr/share/fonts/misc/PowerlineSymbols.otf
#    fc-cache -vf ~/.fonts/
#    mkdir -p ~/.config/fontconfig/conf.d/
#    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf
#}
[[ ! -d ~/.vim/bundle/coc.nvim/ ]] || {
    # Install coc extensions
    vim +'CocInstall coc-tsserver coc-json coc-html coc-css coc-python coc-phpls coc-prettier coc-eslint coc-yaml' +qall
    # vim +'CocCommand extensions.forceUpdateAll' +qall
    cd $DIR
}

##
# tmux configuration
##
[[ ! -f ~/.tmux.conf ]] || rm ~/.tmux.conf
ln -s  ${DIR}/tmux/tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux/plugins/
[[ -d ~/.tmux/plugins/tpm ]] || {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
        ~/.tmux/plugins/tpm/bin/install_plugins
    }

##
# git configuration
##
[[ ! -f ~/.gitconfig ]] || rm ~/.gitconfig
ln -s  ${DIR}/git/gitconfig ~/.gitconfig
echo -n "Would you like to configure your git name and email? (y/n) => "; read answer
if [[ $answer = "Y" ]] || [[ $answer = "y" ]]; then
    echo -n "What is your git user name => "; read name
    git config --global user.name "$name"
    echo -n "What is your git email => "; read email
    git config --global user.email "$email"
fi

##
# Add some binaries
##
if [[ -d "./bin/" ]]; then
    for file in ${DIR}/bin/* ; do
        [[ -f "/usr/local/bin/$(basename $file)" ]] || \
            sudo ln -s "${file}" "/usr/local/bin/$(basename $file)"
    done
fi

echo "*******************************"
echo "*    Restart your terminal    *"
echo "*******************************"

