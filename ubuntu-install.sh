# this script setup my personal ubuntu setup
# the setup workflow has been used for the following purpose:
# - digital ocean
# - personal desktop
# - perf work desktop

## install basic tools, grouped line by line
sudo apt update && sudo apt upgrade -y
sudo apt install -y ssh git vim zsh tmux docker.io
sudo apt install -y build-essential clang cmake libboost-dev libssl-dev
sudo apt install -y linux-tools-$(uname -r) linux-tools-generic graphviz
sudo apt install -y redis wine64
sudo apt install -y texlive-full pandoc nodejs npm 
sudo apt install -y httpie vegeta kubectl doctl hugo
sudo apt install -y xbindkeys xbindkeys-config xclip
sudo apt install -y tree youtube-dl

## install `oh-my-zsh`
cd ~/dev/dotfiles
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
mv ~/.zshrc ~/.zshrc_old
ln -s zsh/zshrc-linux.conf ~/.zshrc
ln zsh/changkun.zsh-theme ~/.oh-my-zsh/themes/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc

## install python
apt install -y python3-pip
pip3 install virtualenv scipy numpy pandas jupyter tensorflow scikit-learn matplotlib seaborn pillow pyyaml requests

# install golang
GOVERSION=$(curl -s 'https://golang.org/dl/?mode=json' | grep '"version"' | sed 1q | awk '{print $2}' | tr -d ',"')  # get latest go version
GOARCH=$(if [[ $(uname -m) == "x86_64" ]] ; then echo amd64; else echo $(uname -m); fi) # get either amd64 or arm64 (darwin/m1)
wget https://dl.google.com/go/$GOVERSION.linux-$GOARCH.tar.gz
tar xvf $GOVERSION.linux-$GOARCH.tar.gz && rm $GOVERSION.linux-$GOARCH.tar.gz
mv ~/goes/go ~/goes/$GOVERSION
ln -s ~/goes/$GOVERSION ~/goes/go
source ~/.zshrc

# install vim config
cd ~/dev/dotfiles
ln vim/vimrc.config ~/.vimrc
mkdir -p ~/.vim/colors/
ln vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
~/.vim/plugged/YouCompleteMe/install.py --go-completer

# install tmux config
ln tmux/tmux.conf ~/.tmux.conf
ln tmux/tmux.local.conf ~/.tmux.conf.local

# fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh && cd .. && rm -rf fonts
