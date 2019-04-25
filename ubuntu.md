
# Ubuntu Linux

## System Preference

- English system language
- Dark Theme

## Generals

### Ubuntu Software

- Chromium
- Visual Studio Code
- GNOME Tweaks
- Telegram
- Electronic Wechat
- Blender
- MeshLab

### Others

- iCALDAV Calendar: https://p12-caldav.icloud.com
- Rescue Time https://www.rescuetime.com/get_rescuetime
- 1Password X https://support.1password.com/explore/linux/
- Mendeley https://www.mendeley.com/download-desktop/
- Sogou https://pinyin.sogou.com/linux/?r=pinyin
- Typora https://typora.io/#linux
- Slack


```shell
sudo apt update
sudo apt upgrade
sudo apt install


# install zsh
sudo apt install zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zsh/zshrc.conf ~/.zshrc
cp zsh/changkun.zsh-theme ~/.oh-my-zsh/themes/
source ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source ~/.zshrc

# install vim
sudo apt install vim cmake python-dev clang npm
cp vim/vimrc.config ~/.vimrc
mkdir -p ~/.vim/colors/ && cp vim/colors/jellybeans.vim ~/.vim/colors/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
~/.vim/bundle/YouCompleteMe/install.py --clang-completer --tern-completer


# install tmux
sudo apt install fonts-powerline tmux
git clone https://github.com/gpakosz/.tmux.git ~/.tmux
ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
cp ~/.tmux/.tmux.conf.local ~/.
cp tmux/tmux.local.conf ~/.tmux.conf.local
```

and also see [ubuntu-setup.sh](./ubuntu-setup.sh).

Not fully supported yet.