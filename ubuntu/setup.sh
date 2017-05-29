# this script setup my personal ubuntu 16.04 dev-environment

cd ~

## install basic tools
sudo apt-get update
sudo apt-get upgrade
sudo apt-get isntall -y vim zsh git tree clang libboost-dev libssl-dev

## install `oh-my-zsh`
sudo sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

## install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential

## setup taobao npm registry
sudo npm install -g cnpm --registry=https://registry.npm.taobao.org

## install python
sudo apt-get install -y python-pip python3-pip

## install docker
sudo apt-get install -y pt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo sh -c 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list'
sudo apt-get update
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get install -y docker-engine
sudo goupadd docker
sudo usermod -aG docker $USER
sudo service docker start

## setup aliyun docker registry
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/mirror.conf <<-'EOF'
[Service] ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --registry-mirror=https://8dtpr9m3.mirror.aliyuncs.com
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker


## install swift
sudo apt-get install -y libicu-dev
wget https://swift.org/builds/swift-3.0-preview-6/ubuntu1510/swift-3.0-PREVIEW-6/swift-3.0-PREVIEW-6-ubuntu15.10.tar.gz
tar -zxf swift-3.0-PREVIEW-6-ubuntu15.10.tar.gz && rm swift-3.0-PREVIEW-6-ubuntu15.10.tar.gz
sudo mv swift-3.0-PREVIEW-6-ubuntu15.10 /usr/local/share/swift
echo 'export PATH=/usr/local/share/swift/usr/bin:"${PATH}"' >> .zshrc
source .zshrc

## install nginx
