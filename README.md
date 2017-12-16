# Dotfiles
This repo contains my personal **macOS** and **Ubuntu Linux** system dotfiles and settings.

## macOS

- For dotfiles, simplely run [mac-install.sh](./mac-install.sh) to install all dotfiles, it will setup zsh+tmux+vim environment for Python/JS/C/C++;
- For system settings, perform all the following checklist item.

### System Preference

- **English** as Default language
- **Dark** Theme
- **Dock** Size Small/Disable Magnification/Left Position/Genie effect/Double-click title bar to minimize
- **Finder** enable TabBar+StatusBar+PathBar (View -> Show [TabBar|StatusBar|PathBar])
- **QuickLook** Preview [https://github.com/sindresorhus/quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins) 
- **.ssh_config**
- **Global Keyboard Shortcuts**
  - control + space: Spotlight
  - option + space: Eudict
  - shift + space: Dehelper
  - command + space: Input Method
  - ABC - Extended
    - option+s: ß
    - option+u, with a/u/o: ä/ü/ö
  - Sogou Input
    - shift: English/Chinese
- **Trackpad Gestures**
  - Tap click
  - Secondary click
  - Three fingers drag
  - Three fingers tap
- **Additional System Fonts**
  - Powerline Font: [https://github.com/powerline/fonts](https://github.com/powerline/fonts) 

### General

- **Dropbox**: [https://www.dropbox.com/install](https://www.dropbox.com/install) 
- **Chrome**: [https://www.google.com/chrome/index.html](https://www.google.com/chrome/index.html) 
- **Firefox** (Optional): [https://www.mozilla.org/en-US/firefox/desktop/](https://www.mozilla.org/en-US/firefox/desktop/) 
- **Eudict**: [http://www.eudic.net/eudic/mac_dictionary.aspx](http://www.eudic.net/eudic/mac_dictionary.aspx) 
- **Dehelper**: [http://www.francochinois.com/Dehelper/mac.aspx](http://www.francochinois.com/Dehelper/mac.aspx) 
- **Grammarly**: [https://www.grammarly.com/native/mac](https://www.grammarly.com/native/mac) 
- **Spotify** (Optional): [https://www.spotify.com/us/download/](https://www.spotify.com/us/download/) 
- **Slack**: [https://slack.com/downloads/osx](https://slack.com/downloads/osx) 
- **IINA**: [https://github.com/lhc70000/iina](https://github.com/lhc70000/iina) 
- **Sogou**: [http://pinyin.sogou.com/mac/?r=pinyin](http://pinyin.sogou.com/mac/?r=pinyin)
- **1Password**: AppStore
- **QQ**: AppStore
- **WeChat**: AppStore
- **WhatsApp**: AppStore
- **Telegram**: AppStore
- **Skype**: AppStore
- **Photoshop** (**Affinity Photo**): AppStore
- **NeteaseMusic**: AppStore
- **YoudaoDict** (Optional): AppStore

### Development

- **iTerm2**: [https://www.iterm2.com](https://www.iterm2.com)
  - Color Presets: [changkun.itermcolors](./changkun.itermcolors)
  - Profile: [com.googlecode.iterm2.plist](com.googlecode.iterm2.plist)
    - **send text at start** tmux attach -d -t dev || tmux new -s dev
    - **Cusor** Underline
    - **Font** 16pt Ubuntu Mono derivative Powerline
    - **Text Rendering** Disable Draw bold in bold font
    - **Text Rendering** Disable Draw bold in bright colors
    - **Text Rendering** Enable Draw anti-aliased text with thin strokes
    - **Window appearence** Transparency to 15%
    - **Window appearence** Blur to 40%
    - **Terminal Emulation** Unicode (UTF-8), xterm-256color
- **SourceTree**: [https://www.sourcetreeapp.com](https://www.sourcetreeapp.com) 
- **VSCode**: [https://code.visualstudio.com](https://code.visualstudio.com) 
- **Docker** for Mac: [https://docs.docker.com/docker-for-mac/](https://docs.docker.com/docker-for-mac/) 
- **Postman**: [https://www.getpostman.com/apps](https://www.getpostman.com/apps) 
- **Dash**: [https://kapeli.com/dash](https://kapeli.com/dash)
- **Robo 3T**: [https://robomongo.org/](https://robomongo.org/)
- **Xcode** (Optional): AppStore
- **PyCharm** (Optional): [https://www.jetbrains.com/pycharm/](https://www.jetbrains.com/pycharm/)
- **WebStorm** (Optional): [https://www.jetbrains.com/webstorm/](https://www.jetbrains.com/webstorm/)

### Environment

- **Bash**: 
- - **zsh**, oh-my-zsh: [https://github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

    - general: [zshrc.conf](./zshrc.conf)
    - zsh **theme**
      - [changkun.zsh-theme](./changkun.zsh-theme)

  - **brew**: [https://brew.sh](https://brew.sh) 

  - - brew tap homebrew/science
    - python
    - python3
    - youtube-dl
    - pandoc
    - pdf2htmlex
    - tree
    - wget
    - tmux
    - macvim
    - node
    - cmake
    - rmtrash
- VIM:

  - [.vimrc](./.vimrc)
    - vundle.vim: [https://github.com/VundleVim/Vundle.vim](https://github.com/VundleVim/Vundle.vim) 
    - YouCompleteMe: https://github.com/Valloric/YouCompleteMe
    - lightline.vim: https://github.com/itchyny/lightline.vim
  - Settings
    - Python
    - JavaScript
    - C/C++
- TMUX:
  - [tmux.conf](./tmux.conf)
  - [tmux.conf.local](./tmux.conf.local)
- VSCode:
  - C/C++
  - Debugger for Chrome
  - Docker
  - Docker Linter
  - Docker Runner
  - ESLint
  - Jupyter
  - LaTeX Language Support
  - Python
  - Material Theme
  - language-stylus
  - HTML Snippets
  - Swig
  - TSLint
  - Sublime Text Key
  - vscode-icons
  - vscode-pandoc
  - vscode-pdf
  - vue
- Server
  - Apache

### Writing

- Typora: [https://typora.io](https://typora.io) 
- MacTeX: [http://tug.org/mactex/mactex-download.html](http://mactex.org)
- Office: [https://stores.office.com/myaccount/home.aspx#install](https://stores.office.com/myaccount/home.aspx#install)
- Mendeley: [https://www.mendeley.com/download-mendeley-desktop/](https://www.mendeley.com/download-mendeley-desktop/) 
- Evernote: AppStore
- MindNode: AppStore
- OmniGraffle: AppStore
- PDF Expert: AppStore

### Utils

- ShadowsocksX-NG: [https://github.com/shadowsocks/ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG)
- The Unarchiver: AppStore
- Wunderlist: AppStore
- iStatu Menu: [https://bjango.com/mac/istatmenus/](https://bjango.com/mac/istatmenus/) 
- Bartender: [https://www.macbartender.com](https://www.macbartender.com)
- Alfred: [https://www.alfredapp.com](https://www.alfredapp.com)
- KeyCast: [https://github.com/cho45/KeyCast](https://github.com/cho45/KeyCast)


### Pro Optional

- CUDA: [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)
- cuDNN: [https://developer.nvidia.com/cudnn](https://developer.nvidia.com/cudnn)
- JDK: [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Xcode: AppStore
- OBS: [https://obsproject.com/download](https://obsproject.com/download) 

### Games

- Minecraft: https://minecraft.net
- Steam: http://steampowered.com

## Ubuntu Linux

see [ubuntu-setup.sh](./ubuntu-setup.sh).

Not fully supported yet.

## License

changkun © MIT 