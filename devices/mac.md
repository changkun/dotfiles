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

### General

- Dropbox: https://www.dropbox.com/install
- Chrome: https://www.google.com/chrome/index.html
- **Grammarly**: https://www.grammarly.com/native/mac
- **IINA**: https://github.com/lhc70000/iina
- 1Password: https://1password.com/downloads/mac
- **WeChat**: AppStore
- **Telegram**: AppStore
- WhatsApp: AppStore
- Slack: https://slack.com/downloads/mac
- **Photoshop** (**Affinity Photo**): AppStore

### Development

- **Ghostty**: https://ghostty.org/
    ```
    macos-option-as-alt = true
    keybind = ctrl+a>\=new_split:right
    keybind = ctrl+a>-=new_split:down
    ```

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
- Podman: https://podman.io/

### AI

- Claude: https://claude.com/download
- Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
  - installs into `~/.local/bin`, which [zshrc-mac.conf](../zsh/zshrc-mac.conf) already puts on `$PATH`
- ChatGPT: https://openai.com/chatgpt/desktop/
- Ollama: https://ollama.com/download

### Environment

- **Bash**:
- oh-my-zsh: https://github.com/robbyrussell/oh-my-zsh
  - brew: https://brew.sh
- VIM:
  - [.vimrc](../.vimrc)
- TMUX:
  - [tmux.conf](../tmux.conf)
  - [tmux.conf.local](../tmux.conf.local)

### Writing

- MacTeX: http://www.tug.org/mactex/mactex-download.html
- Klatexformula: https://klatexformula.sourceforge.io/downloads
- PDF Expert: AppStore
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

- Shadowrocket: AppStore
- Things 3: AppStore
- Magnet: AppStore
- Tailscale: https://tailscale.com/download/mac
- Zoom: https://zoom.us/

### Optional

- Blender: https://www.blender.org/download/
- MeshLab: http://www.meshlab.net/#download
- Xcode: AppStore
- OBS: https://obsproject.com/download
- HandBrake: https://handbrake.fr/downloads.php
- Adobe Acrobat Reader (for special purpose)
- Postman: https://www.getpostman.com/apps
- Discord: https://discord.com/download

### Entertainment

- Minecraft: https://minecraft.net
- Steam: http://steampowered.com


```
$ cat ~/.gitconfig                                              main ● [16:45:48]
[user]
        name = Changkun Ou
        email = hi@changkun.de
[init]
        defaultBranch = main
[url "ssh://git@github.com/"]
        insteadOf = https://github.com/
[http]
        cookiefile = /Users/changkun/.gitcookies
[filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true
[credential "https://github.com"]
        helper =
        helper = !/opt/homebrew/bin/gh auth git-credential
[credential "https://gist.github.com"]
        helper =
        helper = !/opt/homebrew/bin/gh auth git-credential
[credential "https://code.latere.ai"]
        helper =
        helper = !latere git-credential
```