#!/bin/bash

STARTIME=$(date +%s)
LOGFILE="install.log"
#https://misc.flogisoft.com/bash/tip_colors_and_formatting
BLINK='\e[5m'
BOLD='\e[1m'
LIGHT_GREEN='\e[92m'
LIGHT_YELLOW='\e[93m'
NORMAL='\e[0m'
RED='\e[31m'
UNDERLINE='\e[4m'
#=============================#


testcmd () {
    command -v "$1" >/dev/null
}

# Wipe log file on every install
echo "" > $LOGFILE


echo -e "${BOLD}[~] Installing bug bounty tools...${NORMAL}"
echo -e "=========================================\n"

echo -e "${BOLD}${LIGHT_GREEN}[+] Installing git jq gcc make libpcap-dev unzip tmux...${NORMAL}"
sudo apt-get install -y git jq gcc make libpcap-dev unzip tmux >> $LOGFILE 2>&1

if [ ! -x /usr/local/go/bin/go ]; then

    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing golang...${NORMAL}"
    wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz -O golang-13.5.tar.gz
    sudo tar -C /usr/local -xzf golang-13.5.tar.gz
    rm -rf golang-13.5.tar.gz

    echo -e "${BOLD}${LIGHT_GREEN}[+] Adding Go to PATH...${NORMAL}"
    echo "export GOPATH=$HOME/go" >> $HOME/.profile
    echo "export PATH=$HOME/go/bin:/usr/local/go/bin:$PATH" >> $HOME/.profile
    source $HOME/.profile
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

if ! testcmd gobuster; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gobuster...${NORMAL}"
    go get github.com/OJ/gobuster
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gobuster...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd waybackurls; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackurls...${NORMAL}"
    go get -u github.com/tomnomnom/waybackurls
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing waybackurls...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd httprobe; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httprobe...${NORMAL}"
    go get -u github.com/tomnomnom/httprobe
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing httprobe...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd meg; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${NORMAL}"
    go get -u github.com/tomnomnom/meg
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing meg...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd unfurl; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${NORMAL}"
    go get -u github.com/tomnomnom/unfurl
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing unfurl...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd gowitness; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${NORMAL}"
    go get -u github.com/sensepost/gowitness
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing gowitness...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd getJS; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${NORMAL}"
    go get -u github.com/003random/getJS
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing GetJS...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd subzy; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Subzy...${NORMAL}"
    go get -u github.com/lukasikic/subzy
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing Subzy...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd SubOver; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SubOver...${NORMAL}"
    go get -u github.com/Ice3man543/SubOver
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SubOver...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
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
    python3.8 -m pip install dnsgen --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing dnsgen...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd trufflehog; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${NORMAL}"
    python3.8 -m pip install truffleHog --user
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing trufflehog...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd googd0rker.py; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing googd0rker.py...${NORMAL}"
    sudo curl https://raw.githubusercontent.com/LuD1161/GoogD0rker/master/googd0rker.py -o /bin/googd0rker.py
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing googd0rker.py...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi


echo -e "\n-----------------------------------------"
echo -e "${BOLD}${LIGHT_YELLOW}[~] Installing misc tools${NORMAL}"
echo "-----------------------------------------"

if [ ! -f "/opt/chromedriver" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to /opt/...${NORMAL}"
    wget https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip -O chromedriver.zip
    unzip chromedriver.zip
    sudo mv chromedriver /opt/
    rm -rf chromedriver.zip
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing chromedriver to /opt/...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi


if ! testcmd massdns; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing massdns...${NORMAL}"
    git clone https://github.com/blechschmidt/massdns.git
    cd massdns
    make >> $LOGFILE 2>&1
    sudo mv bin/massdns /usr/local/bin
    cd ..
    rm -rf massdns
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing massdns...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
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
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing masscan...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if [ ! -d "/opt/seclists" ]; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to /opt/...${NORMAL}"
    sudo git clone https://github.com/danielmiessler/SecLists.git /opt/seclists
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing SecLists to /opt/...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd whatweb; then
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing whatweb...${NORMAL}"
    sudo apt-get install -yq whatweb >> $LOGFILE 2>&1
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing whatweb...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi

if ! testcmd nmap; then

    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmap...${NORMAL}"
    git clone https://github.com/nmap/nmap.git
    cd nmap
    echo "[!] Configuring nmap..."
    sh ./configure >> $LOGFILE 2>&1
    echo "[!] Running make nmap..."
    make >> $LOGFILE 2>&1
    echo "[!] Runing make install nmap..."
    make install >> $LOGFILE 2>&1
    cd ..
    rm -rf nmap
else
    echo -e "${BOLD}${LIGHT_GREEN}[+] Installing nmap...${LIGHT_YELLOW}[SKIPPED]${NORMAL}"
fi


echo -e "\n========================================="
echo -e "${BOLD}~ BountyStrike-sh installation complete ~${NORMAL}"
echo -e "${BOLD}~ Enjoy your bounties :) ~${NORMAL}\n"