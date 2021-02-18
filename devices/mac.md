# macOS

- For dotfiles, simplely run [mac-install.sh](../mac-install.sh) to install all dotfiles, it will setup zsh+tmux+vim environment for Python/JS/C/C++;
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
  - Powerline Font: https://github.com/changkun/fonts
- Font rendering: `defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO` This is for VSCode

### General

- Dropbox: https://www.dropbox.com/install
- Chrome: https://www.google.com/chrome/index.html
- **Eudict**: http://www.eudic.net/eudic/mac_dictionary.aspx
- **Dehelper**: http://www.francochinois.com/Dehelper/mac.aspx
- **Grammarly**: https://www.grammarly.com/native/mac
- **IINA**: https://github.com/lhc70000/iina
- **1Password**: AppStore
- **WeChat**: AppStore
- **Telegram**: AppStore
- **Photoshop** (**Affinity Photo**): AppStore

### Development

- **iTerm2**: https://www.iterm2.com
  - Color Presets: [changkun.itermcolors](../iterm2/changkun.itermcolors)
  - Profile: [com.googlecode.iterm2.plist](../iterm2/com.googlecode.iterm2.plist)
  - Key-binding: [keys.itermkeymap](../iterm2/keys.itermkeymap)
    - **send text at start** tmux attach -d -t dev || tmux new -s dev
    - **Cusor** Underline
    - **Font** 16pt Ubuntu Mono derivative Powerline
    - **Text Rendering** Disable Draw bold in bold font
    - **Text Rendering** Disable Draw bold in bright colors
    - **Text Rendering** Enable Draw anti-aliased text with thin strokes
    - **Window appearence** Transparency to 15%
    - **Window appearence** Blur to 40%
    - **Terminal Emulation** Unicode (UTF-8), xterm-256color
- VSCode: https://code.visualstudio.com
- Xcode: AppStore
- Docker for Mac: https://docs.docker.com/docker-for-mac/

### Environment

- **Bash**: 
- oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh
  - brew: https://brew.sh 
- VIM:
  - [.vimrc](../.vimrc)
- TMUX:
  - [tmux.conf](../tmux.conf)
  - [tmux.conf.local](../tmux.conf.local)
- VSCode: code --list-extensions | xargs -L 1 echo code --install-extension
  ```
  code --install-extension bungcip.better-toml
  code --install-extension circledev.glsl-canvas
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension donjayamanne.jupyter
  code --install-extension eamodio.gitlens
  code --install-extension Equinusocio.vsc-community-material-theme
  code --install-extension Equinusocio.vsc-material-theme
  code --install-extension equinusocio.vsc-material-theme-icons
  code --install-extension eriklynd.json-tools
  code --install-extension felipe-mendes.slack-theme
  code --install-extension felixfbecker.php-intellisense
  code --install-extension formulahendry.vscode-mysql
  code --install-extension golang.go
  code --install-extension James-Yu.latex-workshop
  code --install-extension janisdd.vscode-edit-csv
  code --install-extension johnstoncode.svn-scm
  code --install-extension maelvalais.autoconf
  code --install-extension mechatroner.rainbow-csv
  code --install-extension mrjjot.vscode-glsl-linter
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
  code --install-extension ms-python.python
  code --install-extension ms-toolsai.jupyter
  code --install-extension ms-vscode-remote.remote-ssh
  code --install-extension ms-vscode-remote.remote-ssh-edit
  code --install-extension ms-vscode.cpptools
  code --install-extension njpwerner.autodocstring
  code --install-extension octref.vetur
  code --install-extension PKief.material-icon-theme
  code --install-extension PsykoSoldi3r.itunes-vscode
  code --install-extension quillaja.goasm
  code --install-extension redhat.vscode-yaml
  code --install-extension rust-lang.rust
  code --install-extension slevesque.shader
  code --install-extension tomoki1207.pdf
  code --install-extension vscode-icons-team.vscode-icons
  code --install-extension vscodevim.vim
  code --install-extension WakaTime.vscode-wakatime
  code --install-extension wayou.vscode-todo-highlight
  code --install-extension yzhang.markdown-all-in-one
  code --install-extension zhouronghui.propertylist
  code --install-extension znck.grammarly
  code --install-extension zxh404.vscode-proto3
  ```

### Writing

- Typora: https://typora.io 
- MacTeX: http://www.tug.org/mactex/mactex-download.html
- Klatexformula: https://klatexformula.sourceforge.io/downloads
- MindNode: AppStore
- OmniGraffle: AppStore
- PDF Expert: AppStore
- Mendeley: https://www.mendeley.com/download-mendeley-desktop/ 
- Zotero: https://www.zotero.org/download/
  + Plugin Zotfile: http://zotfile.com/
  + Config: base directory to dropbox, zotfile source folder from download, and location of files to dropbox (automatic move).
  + Use subfolders: `/%c` on macOS/Linux, `\\%c` on windows
  + Rename rules: `{%y-}{%a-}{%t}`
  + Delimiter between multiple lines `-`
  + Change to lower case
  + Replace blanks
  + Truncate title after `.` or `:` or `?`
  + Maximum length of title 80
  + Maximum number of authors 2
  + Add suffix when authors are omitted `etal`
### Utils

- ShadowsocksX-NG: https://github.com/shadowsocks/ShadowsocksX-NG
- The Unarchiver: AppStore
- Things 3: AppStore
- iStatu Menu: https://bjango.com/mac/istatmenus/
- Bartender: https://www.macbartender.com
- Alfred: https://www.alfredapp.com
- Zoom: https://zoom.us/

### Optional

- Blender: https://www.blender.org/download/
- MeshLab: http://www.meshlab.net/#download
- CUDA: https://developer.nvidia.com/cuda-downloads
- cuDNN: https://developer.nvidia.com/cudnn
- JDK: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
- Xcode: AppStore
- OBS: https://obsproject.com/download
- Medis: https://github.com/luin/medis/releases/tag/v0.5.0
- Sequel Pro: https://sequelpro.com/download
- HandBrake: https://handbrake.fr/downloads.php
- Adobe Acrobat Reader (for special purpose)
- Office: https://stores.office.com/myaccount/home.aspx#install
- Postman: https://www.getpostman.com/apps
- Dash: https://kapeli.com/dash
- Robo 3T: https://robomongo.org/
- SourceTree: https://www.sourcetreeapp.com
- Discord: https://discord.com/download
- Gifski: AppStore

### Entertainment

- Minecraft: https://minecraft.net
- Steam: http://steampowered.com
- YYets: http://app.rrys.tv/
