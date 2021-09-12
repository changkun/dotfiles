## General softwares

NVIDIA stuff:

- NVIDIA driver: https://www.nvidia.com/Download/index.aspx
- CUDA https://developer.nvidia.com/cuda-downloads
- cuDNN: https://developer.nvidia.com/cudnn
- cuBLAS, cuSOLVER, cuFFT...: https://developer.nvidia.com/hpc-sdk
- DALI: https://github.com/NVIDIA/dali
- Nsight: https://developer.nvidia.com/nsight-visual-studio-edition

GUI softwares:

- Chromium (nightly, with webgpu support): https://www.google.com/intl/en/chrome/canary/
- Houdini: https://www.sidefx.com/download/
- Docker: https://docs.docker.com/desktop/windows/install/
- Docker Compose: https://docs.docker.com/compose/install/
- Tailscale: https://tailscale.com/download

Probably don't need administrator rights (not sure):

- Visual Studio Code: https://code.visualstudio.com/
- Blender: https://www.blender.org/download/
- klatexformula: https://klatexformula.sourceforge.io/downloads

Visual Studio Community: https://visualstudio.microsoft.com/vs/community/

- workloads:
  + web & cloud:
    * python development
    * nodejs development
  + desktop & mobile
    * .NET desktop development
    * desktop development with C++
    * mobile development with .NET
    * mobile development with C++
  + Gaming
    * game development with unity
    * game development with C++
  + Other toolsets
    * Data science analytical applications
    * Linux development with C++

Unity

- 2020.3.18f1 for LTS
- 2021.1.20f1 for Visual Scripting

Unreal Engine

- 4.26 for LTS
- 5.0 for Nanite and Lumen system

Dev toolchain:

- choco: https://docs.chocolatey.org/en-us/choco/setup
- mingw
- llvm
- vim
- git
- nvtop
- cmake
- make
- tmux
- tree
- wget
- zsh? what's the relevant Windows version?
- JDK: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
- Android Studio
- Postman: https://www.getpostman.com/apps
- SourceTree: https://www.sourcetreeapp.com
- graphviz
- openssh: https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse
- run service - ssh server

Commands:

- httpie, vegeta
- mongodb-community, redis

## Languages?

- C/C++
- Go
- Python, PIP, miniconda: https://docs.conda.io/en/latest/miniconda.html
- Nodejs, NPM

## Fonts

```
# fonts
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts && ./install.sh && cd .. && rm -rf fonts
```


wsl --install

```
# see https://askubuntu.com/questions/1115564/wsl-ubuntu-distro-how-to-solve-operation-not-permitted-on-cloning-repository 
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata
```