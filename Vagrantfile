# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.synced_folder "data", "/vagrant_data"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim git python-pip build-essential libbz2-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev ntp
    systemctl enable ntp
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update
    sudo pip install --upgrade pip
    sudo pip install docker-compose
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io
    PYTHON_VERSION="3.7.6"
    PYTHON_FILE="Python-3.7.6.tgz"
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_FILE
    tar -xvf $PYTHON_FILE
    rm -rf $PYTHON_FILE
    cd Python-$PYTHON_VERSION
    ./configure
    make -j 1
    sudo make altinstall
    cd ..
    rm -rf Python-$PYTHON_VERSION
  SHELL
end