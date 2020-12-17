
# Linux (Ubuntu Distribution)

## System Preference

- English system language
- Dark Theme

## Software List

- NVIDIA driver
- CUDA https://developer.nvidia.com/cuda-downloads
- Chromium
- Visual Studio Code https://code.visualstudio.com/
- Telegram
- Blender https://www.blender.org/download/
- Zoom https://zoom.us/download
- MeshLab https://www.meshlab.net/#download
- Maya
- Houdini
- Terminus https://github.com/Eugeny/terminus
- iCALDAV Calendar: https://p12-caldav.icloud.com
- 1Password X https://support.1password.com/explore/linux/
- Mendeley https://www.mendeley.com/download-desktop/
- Typora https://typora.io/#linux
- sudo apt install fcitx-googlepinyin
- Remmnia: VNC access to macOS
- Email: Thunderbird Mail
- Dropbox: https://www.dropbox.com/install
- klatexformula: https://klatexformula.sourceforge.io/downloads
- perflock: https://github.com/aclements/perflock
- benchstat: https://pkg.go.dev/golang.org/x/perf/cmd/benchstat
- Docker: https://docs.docker.com/engine/install/ubuntu/
- Docker-compose: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
- LRZ VPN: https://www.lrz.de/services/netz/mobil/vpnpda/
- LRZ VPN: https://www.lrz.de/services/netz/mobil/vpnclient/
- Chinese font setting: https://www.synscope.com/1015/ubuntu%E4%BF%AE%E5%A4%8D%E4%B8%AD%E6%96%87%E5%AD%97%E4%BD%93%E6%B8%B2%E6%9F%93%E9%97%AE%E9%A2%98/
- k3s: https://k3s.io/

# Security Settings

Firewall:

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22022
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 60000:61000/udp
sudo ufw enable
sudo ufw status verbose

Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), deny (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22022                      ALLOW IN    Anywhere
60000:61000/udp            ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
22022 (v6)                 ALLOW IN    Anywhere (v6)
60000:61000/udp (v6)       ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
443/tcp (v6)               ALLOW IN    Anywhere (v6)
```

SSH:

```
# /etc/ssh/sshd_config
Port 22022
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
```

Note that docker containers change iptables that are not reflected in ufw.
See https://askubuntu.com/questions/652556/uncomplicated-firewall-ufw-is-not-blocking-anything-when-using-docker.

Modify the UFW configuration file /etc/ufw/after.rules and add the following rules at the end of the file:

```
# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:ufw-docker-logging-deny - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward

-A DOCKER-USER -j RETURN -s 10.0.0.0/8
-A DOCKER-USER -j RETURN -s 172.16.0.0/12
-A DOCKER-USER -j RETURN -s 192.168.0.0/16

-A DOCKER-USER -p udp -m udp --sport 53 --dport 1024:65535 -j RETURN

-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -d 172.16.0.0/12
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 192.168.0.0/16
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 10.0.0.0/8
-A DOCKER-USER -j ufw-docker-logging-deny -p udp -m udp --dport 0:32767 -d 172.16.0.0/12

-A DOCKER-USER -j RETURN

-A ufw-docker-logging-deny -m limit --limit 3/min --limit-burst 10 -j LOG --log-prefix "[UFW DOCKER BLOCK] "
-A ufw-docker-logging-deny -j DROP

COMMIT
# END UFW AND DOCKER
```

Go Modules under private domain:

```
export GOPRIVATE=my.domain.com/x
git config --global url."git@github.com:".insteadOf "https://github.com/"
```