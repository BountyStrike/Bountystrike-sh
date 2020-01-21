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
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim git python-pip build-essential libbz2-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev ntp
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
    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt-get update
    sudo apt-get install rvm -y
    echo 'source "/etc/profile.d/rvm.sh"' >> ~/.profile
    rvmsudo install ruby-2.6.3
    rvm use ruby-2.6.3
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

if ! testcmd /usr/share/rvm/bin/rvm; then
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

if [ ! -x /usr/local/go/bin/go ]; then

    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing golang...${NORMAL}"
    wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz -O golang-13.5.tar.gz
    sudo tar -C /usr/local -xzf golang-13.5.tar.gz
    rm -rf golang-13.5.tar.gz

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

# Check if the tool exists in $PATH before installing it

if ! testcmd amass; then
    export GO111MODULE=on
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing amass...${NORMAL}"
    go get -u github.com/OWASP/Amass/v3/...
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing amass...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd subfinder; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing subfinder...${NORMAL}"
    go get github.com/projectdiscovery/subfinder/cmd/subfinder
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing subfinder...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd gobuster; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gobuster...${NORMAL}"
    go get github.com/OJ/gobuster
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gobuster...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd waybackurls; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackurls...${NORMAL}"
    go get -u github.com/tomnomnom/waybackurls
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackurls...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd waybackunifier; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackunifier...${NORMAL}"
    go get github.com/mhmdiaa/waybackunifier
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackunifier...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd fff; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing fff...${NORMAL}"
    go get -u github.com/tomnomnom/hacks/fff
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing fff...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd httprobe; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httprobe...${NORMAL}"
    go get -u github.com/tomnomnom/httprobe
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httprobe...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd meg; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${NORMAL}"
    go get -u github.com/tomnomnom/meg
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd unfurl; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${NORMAL}"
    go get -u github.com/tomnomnom/unfurl
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd filter-resolved; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing filter-resolved...${NORMAL}"
    go get -u github.com/tomnomnom/hacks/filter-resolved
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing filter-resolved...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd gowitness; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${NORMAL}"
    go get -u github.com/sensepost/gowitness
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd getJS; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${NORMAL}"
    go get -u github.com/003random/getJS
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd subzy; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Subzy...${NORMAL}"
    go get -u github.com/lukasikic/subzy
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Subzy...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd SubOver; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SubOver...${NORMAL}"
    go get -u github.com/Ice3man543/SubOver
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SubOver...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd shhgit; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Shhgit...${NORMAL}"
    go get github.com/eth0izzle/shhgit
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Shhgit...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd gitrob; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gitrob...${NORMAL}"
    go get github.com/michenriksen/gitrob
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gitrob...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd aquatone; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing aquatone...${NORMAL}"
    AQUATONE="aquatone-1.7.0.zip"
    wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O $AQUATONE
    unzip $AQUATONE -x LICENSE.txt -x README.md
    sudo mv aquatone /usr/local/bin
    rm -rf $AQUATONE
fi

echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing python tools${NORMAL}"
echo "-----------------------------------------"


if ! testcmd dnsgen; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsgen...${NORMAL}"
    python3.7 -m pip install dnsgen --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsgen...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd trufflehog; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${NORMAL}"
    python3.7 -m pip install truffleHog --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd scout; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing scoutsuite...${NORMAL}"
    python3.7 -m pip install scoutsuite --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing scoutsuite...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if ! testcmd aws; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing awscli...${NORMAL}"
    python3.7 -m pip install awscli --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing awscli...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing ruby tools${NORMAL}"
echo "-----------------------------------------"

if [ ! -d "$TOOLS_DIR/WhatWeb" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing WhatWeb to $TOOLS_DIR/...${NORMAL}"
    git clone https://github.com/urbanadventurer/WhatWeb.git $TOOLS_DIR/WhatWeb
    cd $TOOLS_DIR/WhatWeb
    rvmsudo bundle install # meh
    cd
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing WhatWeb to $TOOLS_DIR/...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing misc tools${NORMAL}"
echo "-----------------------------------------"

if [ ! -f "$TOOLS_DIR/chromedriver" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to $TOOLS_DIR...${NORMAL}"
    wget https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip -O chromedriver.zip
    unzip chromedriver.zip
    sudo mv chromedriver $TOOLS_DIR
    rm -rf chromedriver.zip
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to $TOOLS_DIR...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
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
    sudo git clone https://github.com/danielmiessler/SecLists.git $TOOLS_DIR/seclists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to $TOOLS_DIR...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/commonspeak2" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Commonspeak2 wordlists to $TOOLS_DIR...${NORMAL}"
    sudo git clone https://github.com/assetnote/commonspeak2-wordlists $TOOLS_DIR/wordlists/commonspeak2
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Commonspeak2 wordlists to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

if [ ! -d "$TOOLS_DIR/wordlists/api_wordlists" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing api_wordlist to $TOOLS_DIR/wordlists...${NORMAL}"
    sudo git clone https://github.com/chrislockard/api_wordlist $TOOLS_DIR/wordlists/api_wordlists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing api_wordlist to $TOOLS_DIR/wordlists...${LIGHT_YELLOW}[ALREADY INSTALLED]${NORMAL}"
fi

# TODO
# https://github.com/fuzzdb-project/fuzzdb
# https://github.com/berzerk0/Probable-Wordlists
# https://github.com/s0md3v/Corsy
# https://github.com/Bo0oM/fuzz.txt
# https://github.com/EnableSecurity/wafw00f
# Make sure to create amass configuration file
# https://github.com/tomnomnom/hacks/tree/master/unisub
# https://github.com/maurosoria/dirsearch

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
