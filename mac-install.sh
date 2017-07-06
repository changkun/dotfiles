# WARNING: PLEASE DO NOT USE THIS SCRIPT


# basic development environment
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew install
brew install wget python python3 tree macvim node youtube-dl tmux pandoc pdf2htmlex cmake rmtrash yarn
# nodejs install
npm install -g hexo-cli gulp-cli typescript
# python install
pip3 install virtualenv scipy numpy matplotlib jupyter tensorflow scikit-learn
# optional packages
pip3 install pyyaml pillow requests flask django pandas seaborn

# install oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
cp zsh/zsh.conf ~/.zshrc
cp zsh/changkun.zsh-theme ~/.oh-my-zsh/themes/
source ~/.zshrc

# install vim
cp vim/vimrc.config ~/.vimrc
cp vim/colors/jellybeans.vim ~/.vim/colors/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
~/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer

# install tmux
cp tmux/tmux.conf ~/.tmux.conf
cp tmux/tmux.conf.local ~/.tmux.conf.local