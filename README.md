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
- **.ssh_config**
- **Global Keyboard Shortcuts**
  - control + space: Spotlight
  - option + space: Eudict
  - shift + space: Dehelper
  - command + space: Input Method
  - ABC - Extended
    - option+s: ß
    - option+u, with a/u/o: ä/ü/ö
- **Trackpad Gestures**
  - Tap click
  - Secondary click
  - Three fingers drag
  - Three fingers tap
- **Additional System Fonts**
  - Powerline Font: [https://github.com/powerline/fonts](https://github.com/powerline/fonts) 
- Font rendering: `defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO` This is for VSCode

### General

- **Dropbox**: [https://www.dropbox.com/install](https://www.dropbox.com/install) 
- **Chrome**: [https://www.google.com/chrome/index.html](https://www.google.com/chrome/index.html) 
- **Eudict**: [http://www.eudic.net/eudic/mac_dictionary.aspx](http://www.eudic.net/eudic/mac_dictionary.aspx) 
- **Dehelper**: [http://www.francochinois.com/Dehelper/mac.aspx](http://www.francochinois.com/Dehelper/mac.aspx) 
- **Grammarly**: [https://www.grammarly.com/native/mac](https://www.grammarly.com/native/mac) 
- **Slack**: [https://slack.com/downloads/osx](https://slack.com/downloads/osx) 
- **IINA**: [https://github.com/lhc70000/iina](https://github.com/lhc70000/iina) 
- **Skype**: [https://go.skype.com/skype.download](https://go.skype.com/skype.download)
- **1Password**: AppStore
- **QQ**: AppStore
- **WeChat**: AppStore
- **WhatsApp**: AppStore
- **Telegram**: AppStore
- **Photoshop** (**Affinity Photo**): AppStore
- **NeteaseMusic**: AppStore

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
- MacTeX: [http://www.tug.org/mactex/mactex-download.html](http://www.tug.org/mactex/mactex-download.html)
- Office: [https://stores.office.com/myaccount/home.aspx#install](https://stores.office.com/myaccount/home.aspx#install)
- Mendeley: [https://www.mendeley.com/download-mendeley-desktop/](https://www.mendeley.com/download-mendeley-desktop/) 
- MindNode: AppStore
- OmniGraffle: AppStore
- PDF Expert: AppStore

### Utils

- ShadowsocksX-NG: [https://github.com/shadowsocks/ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG)
- The Unarchiver: AppStore
- Things 3: AppStore
- iStatu Menu: [https://bjango.com/mac/istatmenus/](https://bjango.com/mac/istatmenus/) 
- Bartender: [https://www.macbartender.com](https://www.macbartender.com)
- Alfred: [https://www.alfredapp.com](https://www.alfredapp.com)
- KeyCast: [https://github.com/cho45/KeyCast](https://github.com/cho45/KeyCast)
- Medis: [https://github.com/luin/medis/releases/tag/v0.5.0](https://github.com/luin/medis/releases/tag/v0.5.0)
- Sequel Pro: [https://sequelpro.com/download](https://sequelpro.com/download)
- Adobe Acrobat Reader (for special purpose): 
- FileZilla: [https://filezilla-project.org/download.php?show_all=1](https://filezilla-project.org/download.php?show_all=1)
- HandBrake: [https://handbrake.fr/downloads.php](https://handbrake.fr/downloads.php)
- Zoom.us: [https://zoom.us/](https://zoom.us/)

### Pro Optional

- CUDA: [https://developer.nvidia.com/cuda-downloads](https://developer.nvidia.com/cuda-downloads)
- cuDNN: [https://developer.nvidia.com/cudnn](https://developer.nvidia.com/cudnn)
- JDK: [http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
- Xcode: AppStore
- OBS: [https://obsproject.com/download](https://obsproject.com/download) 
- Blender: [https://www.blender.org/download/](https://www.blender.org/download/)
- MeshLab: [http://www.meshlab.net/#download](http://www.meshlab.net/#download)

### Entertainment

- Minecraft: https://minecraft.net
- Steam: http://steampowered.com
- YYets: http://app.rrys.tv/

### iPad Pro

WIP

## Ubuntu

see [Ubuntu Linux](./ubuntu.md).

## License

changkun © MIT 
