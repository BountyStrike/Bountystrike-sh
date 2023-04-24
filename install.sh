#!/bin/bash

STARTIME=$(date +%s)
LOGFILE="install.log"
TOOLS_DIR="$HOME/tools"
#https://misc.flogisoft.com/bash/tip_colors_and_formatting
BLINK='\e[5m'
BOLD='\e[1m'
LIGHT_GREEN='\e[92m'
LIGHT_YELLOW='\e[93m'
LIGHT_CYAN='\e[96m'
NORMAL='\e[0m'
RED='\e[31m'
UNDERLINE='\e[4m'
#=============================#


testcmd () {
    command -v "$1" >/dev/null
}

MACHINE=`uname -m`
ARCH=""

if [ $MACHINE = "aarch64" ]; then
	ARCH="arm64"
else
	ARCH="amd64"
fi


# Wipe log file on every install
echo "" > $LOGFILE

installDocker() {
    #sudo systemctl enable ntp
    sudo apt install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
}

select_random_lines() {
  num_lines=$1
  input=$(cat)

  total_lines=$(echo "$input" | wc -l)

  if [ "$num_lines" -gt "$total_lines" ]; then
    echo "Error: Cannot select more lines than the input contains."
    return 1
  fi

  echo "$input" | shuf -n "$num_lines"
}

installPython(){
    PYTHON_VERSION="3.7.6"
    PYTHON_FILE="Python-$PYTHON_VERSION.tgz"
    wget https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_FILE
    tar -xvf $PYTHON_FILE
    rm -rf $PYTHON_FILE
    cd Python-$PYTHON_VERSION
    ./configure
    make -j 1
    sudo make altinstall
    cd ..
    sudo rm -rf Python-$PYTHON_VERSION
}

installRuby(){
    wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz
    gunzip -d ruby-2.7.0.tar.gz
    tar -xvf ruby-2.7.0.tar
    cd ruby-2.7.0/
    ./configure
    make
    sudo make install
    cd ..
    rm -rf ruby-2.7.0
}

installMullvadVPN(){
    if [ $ARCH="amd64" ]; then
        cd ~/
        MULLVADVPN_VERSION="2023.2_amd64"
        wget "https://mullvad.net/media/app/MullvadVPN-$MULLVADVPN_VERSION.deb"
        sudo dpkg -i "MullvadVPN-$MULLVADVPN_VERSION.deb"
        rm "MullvadVPN-$MULLVADVPN_VERSION.deb"
    else
        echo -e "${BOLD}${LIGHT_YELLOW}[+] MullvadVPN only supports linux amd64${NORMAL}"
    fi
}

installRust(){
    if [ $ARCH="amd64" ]; then
        wget https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init
    elif [ $ARCH="arm64" ]; then
        wget https://static.rust-lang.org/rustup/dist/aarch64-unknown-linux-gnu/rustup-init
    else
        echo -e "${BOLD}${LIGHT_YELLOW}[+] Unknown arch, did not install rust...${NORMAL}"
        return
    fi

    chmod +x rustup-init
    ./rustup-init -y
    source "$HOME/.cargo/env"
    git clone https://github.com/dandavison/delta.git
    cd delta
    # cargo build
    # apparently this works better if you are low on memory, though a bit slower
    cargo run --release --verbose --jobs 1
    sudo cp target/release/delta /bin/delta
    cd ..
    rm -rf delta
    rm rustup-init
}

echo -e "${BOLD}${LIGHT_CYAN}\n[~] Bountystrike environment installation${NORMAL}"
echo -e "${BOLD}[~] Installing bug bounty tools...${NORMAL}"
echo -e "=========================================\n"

echo "                                              "
echo "                                        .--::///+  _______________________________________________"
echo "                                  -+sydmmmNNNNNNN |                                               |"
echo "                              ./ymmNNNNNNNNNNNNNN |                                               |"
echo "                            -ymmNNNNNNNNNNNNNNNNN |  It is a shame that your report was a         |"
echo "                           ommmmNNNNNNNNNNNNNNNNN |  duplicate, but bug bounty hunting is         |"
echo "                         .ydmNNNNNNNNNNNNNNNNNNNN |  a complicated profession.                    |"
echo "                         odmmNNNNNNNNNNNNNNNNNNNN |                                               |"
echo "                        /hmmmNNNNNNNNNNNNNNNNMNNN |  They said you were coming, they said you     |"
echo "                        +hmmmNNNNNNNNNNNNNNNNNMMN |  were the best on all platforms, would you    |"
echo "                       ..ymmmNNNNNNNNNNNNNNNNNNNN |  agree?                                       |"
echo "                       :.+so+//:---.......----::- |                                               |"
echo "                       .         ....----:///++++ |  Bounty Hunter, the programs are waiting      |"
echo "                       .-/osy+////:::---...-dNNNN |  for you.                                     |"
echo "                     :sdyyydy             :mNNNNM |                                               |"
echo "                    -hmmdhdmm:         .+hNNNNNNM |  - Yea? Good.                                 |"
echo "                   .odNNmdmmNNo    .:+yNNNNNNNNNN |                                               |"
echo -e "                   -hNNNmNo::mNNNNNNNNNNNNNNNNNNN |             ${LIGHT_GREEN}-+- ${LIGHT_YELLOW}BOUNTYSTRIKE ${LIGHT_GREEN}-+-${NORMAL}              |"
echo "                   -hNNmdNo--/dNNNNNNNNNNNNNNNNNN |                                               |"
echo "                   :dNmmdmd-:+NNNNNNNNNNNNNNNNNNm |  This script will install a bug bounty        |"
echo "                  /hNNmmddmd+mNNNNNNNNNNNNNNds++o |  hunting environment containing tools and     |"
echo "                /dNNNNNmmmmmmmNNNNNNNNNNNmdoosydd |  tradecraft by bounty hunters, for bounty     |"
echo "               sNNNNdyydNNNNmmmmmmNNNNNmyoymNNNNN |  hunters.                                     |"
echo "              :NNmmmdso++dNNNNmmNNNNNdhymNNNNNNNN |                                               |"
echo "              -NmdmmNNdsyohNNNNmmNNNNNNNNNNNNNNNN |  @dubs3c                                      |"
echo "               sdhmmNNNNdyhdNNNNNNNNNNNNNNNNNNNNN |                                               |"
echo "                /yhmNNmmNNNNNNNNNNNNNNNNNNNNNNmhh |                                               |"
echo "                  +yhmmNNNNNNNNNNNNNNNNNNNNNNmh+: |_______________________________________________|"
echo "                    ./dmmmmNNNNNNNNNNNNNNNNmmd."
echo "                      ommmmmNNNNNNNmNmNNNNmmd:"
echo "                      :dmmmmNNNNNmh../oyhhhy:"
echo "                       sdmmmmNNNmmh/++-.+oh."
echo "                        /dmmmmmmmmdo-:/ossd:"
echo "                          /ohhdmmmmmmdddddmh/"
echo "                             -/osyhdddddhyo:"
echo "                                   .----. "

sleep 5

# Create a tools directory 3d-party tools are stored
mkdir -p $TOOLS_DIR

echo -e "${BOLD}${LIGHT_GREEN}[+] Updating system...${NORMAL}"
sudo apt-get update
sudo apt-get upgrade -y

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dependencies...${NORMAL}"
sudo apt-get install -y autoconf chromium-browser apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim git python3-pip build-essential libbz2-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev ntp unzip tmux jq libpcap-dev >> $LOGFILE 2>&1

if ! testcmd docker; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Docker-CE...${NORMAL}"
    installDocker
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Docker-CE...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd python3.7; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Python-3.7.6...${NORMAL}"
    installPython
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Python-3.7.6...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

# i am not going to support ruby anymore
#if ! testcmd ruby; then
#    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Ruby-2.6.3...${NORMAL}"
#    installRuby
#else
#    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Ruby-2.6.3...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
#fi

# i am not going to support nodejs anymore
#if ! testcmd npm; then
#    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing npm...${NORMAL}"
#    bash nodejs.sh
#else
#    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing npm...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
#fi

if ! testcmd mullvad; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing MullvadVPN...${NORMAL}"
    installMullvadVPN
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing MullvadVPN...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -x /usr/local/go/bin/go ]; then

    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing golang...${NORMAL}"
    wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz -O go1.20.2.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
    sudo rm -rf go1.20.2.linux-amd64.tar.gz

    echo -e "${BOLD}${LIGHT_GREEN}[+] Adding Go to PATH...${NORMAL}"
    echo "export GOPATH=$HOME/go" >> "$HOME/.profile"
    echo "export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH" >> "$HOME/.profile"
    source "$HOME/.profile"
    echo "[!] Done, run \"source $HOME/.profile\" when install is done."

fi

if ! testcmd /usr/local/go/bin/go; then
    echo -e "${RED}[-] Go was not installed :/${NORMAL}"
    echo -e "${RED}[-] Exiting${NORMAL}"
    exit
fi


echo "-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing go tools${NORMAL}"
echo "-----------------------------------------"

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Nuclei...${NORMAL}"
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing puredns...${NORMAL}"
go install github.com/d3mondev/puredns/v2@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httpx...${NORMAL}"
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing amass...${NORMAL}"
go install github.com/owasp-amass/amass/v3/...@master

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing subfinder...${NORMAL}"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gobuster...${NORMAL}"
go install github.com/OJ/gobuster/v3@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackurls...${NORMAL}"
go install github.com/tomnomnom/waybackurls@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${NORMAL}"
go install github.com/tomnomnom/meg@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${NORMAL}"
go install github.com/tomnomnom/unfurl@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${NORMAL}"
go install github.com/sensepost/gowitness@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${NORMAL}"
go install github.com/003random/getJS@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Shhgit...${NORMAL}"
go install github.com/eth0izzle/shhgit@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gitrob...${NORMAL}"
go install github.com/michenriksen/gitrob@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing ffuf...${NORMAL}"
go install github.com/ffuf/ffuf/v2@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing anew...${NORMAL}"
go install -v github.com/tomnomnom/anew@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gau...${NORMAL}"
go install github.com/lc/gau/v2/cmd/gau@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmapclean...${NORMAL}"
go install github.com/dubs3c/nmapclean@latest


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing python tools${NORMAL}"
echo "-----------------------------------------"

echo "export PATH=$HOME/.local/bin:$PATH" >> "$HOME/.profile"
source $HOME/.profile

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsgen...${NORMAL}"
pip install dnsgen --user

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${NORMAL}"
pip install truffleHog --user

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing scoutsuite...${NORMAL}"
pip install scoutsuite --user

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing awscli...${NORMAL}"
pip install awscli --user

if ! testcmd wafw00f; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing wafw00f...${NORMAL}"
    git clone https://github.com/EnableSecurity/wafw00f.git $TOOLS_DIR/wafw00f
    cd $TOOLS_DIR/wafw00f
    python3 setup.py install --user
    cd
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing wafw00f...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing misc tools${NORMAL}"
echo "-----------------------------------------"

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing testssl...${NORMAL}"
git clone --depth 1 https://github.com/drwetter/testssl.sh.git $TOOLS_DIR/testssl

if [ $ARCH="amd64" ]; then
    cd ~/
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to $TOOLS_DIR...${NORMAL}"
    wget https://chromedriver.storage.googleapis.com/110.0.5481.77/chromedriver_linux64.zip -O chromedriver.zip
    unzip chromedriver.zip
    mv chromedriver $TOOLS_DIR
    rm LICENSE.chromedriver
    rm -rf chromedriver.zip
else
    echo -e "${BOLD}${LIGHT_YELLOW}[+] Chromedriver only supports linux amd64${NORMAL}"
fi

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsvalidator...${NORMAL}"
git clone https://github.com/vortexau/dnsvalidator.git
cd dnsvalidator
sudo python3 setup.py install
cd ..

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing massdns...${NORMAL}"
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make >> $LOGFILE 2>&1
sudo mv bin/massdns /usr/local/bin
cp lists/resolvers.txt $TOOLS_DIR/resolvers.txt
cd ..
rm -rf massdns

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing masscan...${NORMAL}"
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make -j >> $LOGFILE 2>&1
sudo mv ./bin/masscan /usr/bin/
cd ..
rm -rf masscan

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmap...${NORMAL}"
git clone https://github.com/nmap/nmap.git
cd nmap
echo -e "${LIGHT_CYAN}[!] Configuring nmap...${NORMAL}"
sh ./configure
echo -e "${LIGHT_CYAN}[!] Running make nmap...${NORMAL}"
make
echo -e "${LIGHT_CYAN}[!] Runing make install nmap...${NORMAL}"
sudo make install
cd ..
rm -rf nmap

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing rust...${NORMAL}"
installRust

echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing wordlists${NORMAL}"
echo "-----------------------------------------"

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to $TOOLS_DIR...${NORMAL}"
git clone https://github.com/danielmiessler/SecLists.git $TOOLS_DIR/wordlists/seclists

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Commonspeak2 wordlists to $TOOLS_DIR...${NORMAL}"
git clone https://github.com/assetnote/commonspeak2-wordlists $TOOLS_DIR/wordlists/commonspeak2

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing api_wordlist to $TOOLS_DIR/wordlists...${NORMAL}"
git clone https://github.com/chrislockard/api_wordlist $TOOLS_DIR/wordlists/api_wordlists

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Probable-Wordlists to $TOOLS_DIR/wordlists...${NORMAL}"
git clone https://github.com/berzerk0/Probable-Wordlists $TOOLS_DIR/wordlists/Probable-Wordlists

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing jhaddix all.txt to $TOOLS_DIR/wordlists...${NORMAL}"
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt -O $TOOLS_DIR/wordlists/all.txt

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing assetnote automated wordlists to $TOOLS_DIR/wordlists...${NORMAL}"
wget -r --no-parent -R "index.html*" https://wordlists-cdn.assetnote.io/data/automated/ -nH
mkdir $TOOLS_DIR/wordlists/assetnote
mv data/automated $TOOLS_DIR/wordlists/assetnote/automated
rm -rf data

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmap vulnscan...${NORMAL}"
git clone https://github.com/scipag/vulscan.git $TOOLS_DIR/vulnscan
cd $TOOLS_DIR/vulnscan
bash update.sh
cd ~/

echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Creating resolvers.txt - will return after 60 seconds${NORMAL}"
echo "-----------------------------------------"
timeout 60s dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 15 -o $TOOLS_DIR/original-resolvers.txt
cat $TOOLS_DIR/original-resolvers.txt | select_random_lines 15 > $TOOLS_DIR/resolvers.txt

################### the end
echo "export TOOLS_DIR=$HOME/tools" >> "$HOME/.profile"

echo -e "${LIGHT_CYAN}\n[+] Looks like we are done? You may need to run source ~/.profile in order for some programs to take effect${NORMAL}"

echo -e "\n========================================="
echo -e "${BOLD}${LIGHT_YELLOW}~ BountyStrike-sh installation complete ~${NORMAL}"
echo -e "${BOLD}${LIGHT_GREEN}~ Enjoy your bounties ~${NORMAL}\n"
