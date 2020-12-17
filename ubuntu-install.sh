# this script setup my personal ubuntu setup
# the setup workflow has been used for the following purpose:
# - digital ocean
# - personal desktop
# - perf work desktop

cd ~

## install basic tools
sudo apt update && sudo apt upgrade -y
sudo apt install -y git build-essential vim zsh ssh tree clang cmake libboost-dev libssl-dev tmux httpie vegeta youtube-dl pandoc redis docker.io nodejs npm hugo subversion linux-tools-$(uname -r) linux-tools-generic wine64 texlive-full graphviz xbindkeys xbindkeys-config xclip kubectl doctl

## install `oh-my-zsh`
cd ~/dev/dotfiles
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
mv ~/.zshrc ~/.zshrc_old
ln zsh/zshrc-mac.conf ~/.zshrc
ln zsh/changkun.zsh-theme ~/.oh-my-zsh/themes/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc

## install python
apt install -y python3-pip
pip3 install virtualenv scipy numpy pandas jupyter tensorflow scikit-learn matplotlib seaborn pillow pyyaml requests

# install golang
mkdir -p ~/goes
cd ~/goes
wget https://dl.google.com/go/go1.15.3.linux-amd64.tar.gz
tar xvf go1.15.3.linux-amd64.tar.gz && rm go1.15.3.linux-amd64.tar.gz
mv ~/goes/go ~/goes/go1.15
ln -s ~/goes/go1.15 ~/goes/go

# install vim config
ln vim/vimrc.config ~/.vimrc
mkdir -p ~/.vim/colors/
ln vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
~/.vim/bundle/YouCompleteMe/install.py --go-completer

# install tmux config
ln tmux/tmux.conf ~/.tmux.conf
ln tmux/tmux.local.conf ~/.tmux.conf.local

# fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh && cd .. && rm -rf fonts
