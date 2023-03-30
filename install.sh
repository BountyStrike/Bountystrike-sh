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

# Wipe log file on every install
echo "" > $LOGFILE

installDocker() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim git python-pip python3-pip build-essential libbz2-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev ntp
    sudo systemctl enable ntp
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update
    sudo pip install --upgrade pip
    sudo pip install docker-compose
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io
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
    # Should check system architecture before downloading this
    MULLVADVPN_VERSION="2023.2_amd64"
    wget "https://mullvad.net/media/app/MullvadVPN-$MULLVADVPN_VERSION.deb"
    sudo dpkg -i "MullvadVPN-$MULLVADVPN_VERSION.deb"
    rm "MullvadVPN-$MULLVADVPN_VERSION.deb"
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

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing git jq gcc make libpcap-dev unzip tmux chromium-browser software-properties-common chromium-chromedriver...${NORMAL}"
sudo apt-get install -y git jq gcc make libpcap-dev unzip tmux chromium-browser chromium-chromedriver >> $LOGFILE 2>&1

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

if ! testcmd ruby; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Ruby-2.6.3...${NORMAL}"
    installRuby
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Ruby-2.6.3...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd npm; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing npm...${NORMAL}"
    bash nodejs.sh
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing npm...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd mullvad; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing MullvadVPN...${NORMAL}"
    installMullvadVPN
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing MullvadVPN...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -x /usr/local/go/bin/go ]; then

    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing golang...${NORMAL}"
    wget https://go.dev/dl/go1.20.2.linux-amd64.tar.gz -O go1.20.2.linux-amd64.tar.gz
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.20.2.linux-amd64.tar.gz
    rm -rf go1.20.2.linux-amd64.tar.gz

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
go install -u github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

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

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing fff...${NORMAL}"
go get github.com/tomnomnom/fff

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${NORMAL}"
go install github.com/tomnomnom/meg@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${NORMAL}"
go install github.com/tomnomnom/unfurl@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${NORMAL}"
go install github.com/sensepost/gowitness@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${NORMAL}"
go install github.com/003random/getJS@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Subzy...${NORMAL}"
go install github.com/LukaSikic/subzy@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Shhgit...${NORMAL}"
go install github.com/eth0izzle/shhgit@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gitrob...${NORMAL}"
go install github.com/michenriksen/gitrob@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing ffuf...${NORMAL}"
go install github.com/ffuf/ffuf/v2@latest

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httprobe...${NORMAL}"
go install github.com/tomnomnom/httprobe@latest


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing python tools${NORMAL}"
echo "-----------------------------------------"


echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsgen...${NORMAL}"
python3.7 -m pip install dnsgen --user

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${NORMAL}"
python3.7 -m pip install truffleHog --user

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing scoutsuite...${NORMAL}"
python3.7 -m pip install scoutsuite --user


echo -e "${BOLD}${LIGHT_GREEN}[+] Installing awscli...${NORMAL}"
python3.7 -m pip install awscli --user

if ! testcmd wafw00f; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing wafw00f...${NORMAL}"
    git clone https://github.com/EnableSecurity/wafw00f.git $TOOLS_DIR/wafw00f
    cd $TOOLS_DIR/wafw00f
    python3.7 setup.py install --user
    cd
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing wafw00f...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


if [ ! -d "$TOOLS_DIR/flumberboozle" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing flumberboozle...${NORMAL}"
    git clone https://github.com/fellchase/flumberboozle $TOOLS_DIR/flumberboozle
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing flumberboozle...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/bass" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing bass...${NORMAL}"
    git clone https://github.com/Abss0x7tbh/bass $TOOLS_DIR/bass
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing bass...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing ruby tools${NORMAL}"
echo "-----------------------------------------"

if [ ! -d "$TOOLS_DIR/WhatWeb" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing WhatWeb to $TOOLS_DIR/...${NORMAL}"
    git clone https://github.com/urbanadventurer/WhatWeb.git $TOOLS_DIR/WhatWeb
    cd $TOOLS_DIR/WhatWeb
    bundle install
    cd
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing WhatWeb to $TOOLS_DIR/...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing misc tools${NORMAL}"
echo "-----------------------------------------"

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing best-dns-wordlist.txt to $TOOLS_DIR...${NORMAL}"
wget https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt -O $TOOLS_DIR/best-dns-wordlist.txt

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nuclei-templates to $TOOLS_DIR...${NORMAL}"
git clone https://github.com/projectdiscovery/nuclei-templates.git

if [ ! -f "$TOOLS_DIR/chromedriver" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to $TOOLS_DIR...${NORMAL}"
    wget https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip -O chromedriver.zip
    unzip chromedriver.zip
    sudo mv chromedriver $TOOLS_DIR
    rm -rf chromedriver.zip
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to $TOOLS_DIR...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd dnsvalidator; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsvalidator...${NORMAL}"
    git clone https://github.com/vortexau/dnsvalidator.git
    cd dnsvalidator
    python3 setup.py install
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsvalidator...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


if ! testcmd massdns; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing massdns...${NORMAL}"
    git clone https://github.com/blechschmidt/massdns.git
    cd massdns
    make >> $LOGFILE 2>&1
    sudo mv bin/massdns /usr/local/bin
    cp lists/resolvers.txt $TOOLS_DIR/resolvers.txt
    cd ..
    rm -rf massdns
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing massdns...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd masscan; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing masscan...${NORMAL}"
    git clone https://github.com/robertdavidgraham/masscan
    cd masscan
    make -j >> $LOGFILE 2>&1
    sudo mv ./bin/masscan /usr/bin/
    cd ..
    rm -rf masscan
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing masscan...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/seclists" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to $TOOLS_DIR...${NORMAL}"
    git clone https://github.com/danielmiessler/SecLists.git $TOOLS_DIR/seclists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to $TOOLS_DIR...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/commonspeak2" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Commonspeak2 wordlists to $TOOLS_DIR...${NORMAL}"
    git clone https://github.com/assetnote/commonspeak2-wordlists $TOOLS_DIR/wordlists/commonspeak2
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Commonspeak2 wordlists to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/api_wordlists" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing api_wordlist to $TOOLS_DIR/wordlists...${NORMAL}"
    git clone https://github.com/chrislockard/api_wordlist $TOOLS_DIR/wordlists/api_wordlists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing api_wordlist to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/fuzz.txt" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Bo0oM/fuzz.txt to $TOOLS_DIR/wordlists...${NORMAL}"
    git clone https://github.com/Bo0oM/fuzz.txt.git $TOOLS_DIR/wordlists/fuzz.txt
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Bo0oM/fuzz.txt to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/Probable-Wordlists" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Probable-Wordlists to $TOOLS_DIR/wordlists...${NORMAL}"
    git clone https://github.com/berzerk0/Probable-Wordlists $TOOLS_DIR/wordlists/Probable-Wordlists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Probable-Wordlists to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/fuzzdb" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing fuzzdb to $TOOLS_DIR/wordlists...${NORMAL}"
    git clone https://github.com/fuzzdb-project/fuzzdb $TOOLS_DIR/wordlists/fuzzdb
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing fuzzdb to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd nmap; then

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
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmap...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

echo -e "${LIGHT_CYAN}\n[+] Looks like we are done? You may need to run source ~/.profile in order for some programs to take effect${NORMAL}"

echo -e "\n========================================="
echo -e "${BOLD}${LIGHT_YELLOW}~ BountyStrike-sh installation complete ~${NORMAL}"
echo -e "${BOLD}${LIGHT_GREEN}~ Enjoy your bounties ~${NORMAL}\n"
