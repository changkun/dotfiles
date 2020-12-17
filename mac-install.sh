# WARNING: PLEASE DO NOT USE THIS SCRIPT, JUST MANUALLY FOLLOW THE STEPS

# basic development environment
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install
brew tap mongodb/brew
brew install wget python3 tree macvim node youtube-dl tmux pandoc cmake reattach-to-user-namespace mongodb-community redis httpie vegeta kubectl doctl
# nodejs install
npm install -g typescript
# python install
pip3 install virtualenv scipy numpy pandas jupyter tensorflow scikit-learn matplotlib seaborn pillow

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
mv ~/.zshrc ~/.zshrc_old
ln zsh/zshrc-mac.conf ~/.zshrc
ln zsh/changkun.zsh-theme ~/.oh-my-zsh/themes/
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc

# install golang
mkdir -p ~/goes
cd ~/goes
wget https://dl.google.com/go/go1.15.6.linux-amd64.tar.gz
tar xvf go1.15.6.linux-amd64.tar.gz && rm go1.15.6.linux-amd64.tar.gz
mv ~/goes/go ~/goes/go1.15
ln -s ~/goes/go1.15 ~/goes/go
source ~/.zshrc
go install changkun.de/x/cmd/{rmtrash,tli}

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

