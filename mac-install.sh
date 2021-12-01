# WARNING: PLEASE DO NOT USE THIS SCRIPT, JUST MANUALLY FOLLOW THE STEPS

# basic development environment
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install
brew tap mongodb/brew
brew install wget python3 tree macvim node youtube-dl tmux pandoc cmake cmake-docs reattach-to-user-namespace mongodb-community redis httpie vegeta
# nodejs install
npm install -g typescript
# python install
pip3 install virtualenv scipy numpy pandas jupyter tensorflow scikit-learn matplotlib seaborn pillow

# install autojump
git clone git://github.com/wting/autojump.git
cd autojump && ./install.py && cd .. && rm -rf autojump

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
GOVERSION=$(curl -s 'https://go.dev/dl/?mode=json' | grep '"version"' | sed 1q | awk '{print $2}' | tr -d ',"')  # get latest go version
GOARCH=$(if [[ $(uname -m) == "x86_64" ]] ; then echo amd64; else echo $(uname -m); fi) # get either amd64 or arm64 (darwin/m1)
wget https://dl.google.com/go/$GOVERSION.darwin-$GOARCH.tar.gz
tar xvf $GOVERSION.darwin-$GOARCH.tar.gz && rm $GOVERSION.darwin-$GOARCH.tar.gz
mv ~/goes/go ~/goes/$GOVERSION
ln -s ~/goes/$GOVERSION ~/goes/go
source ~/.zshrc
go install changkun.de/x/{rmtrash,tli,ser}@latest

# install vim config
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

