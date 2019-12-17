#!/bin/bash

echo "[~] Installing bug bounty tools..."
echo "======================================"

apt-get install git

echo "[+] Installing golang..."
wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz -O golang-13.5.tar.gz
tar -C /usr/local -xzf golang-13.5.tar.gz
rm -rf golang-13.5.tar.gz

echo "[+] Adding /usr/local/go/bin to PATH..."
echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile
echo "[+] Done, run source $HOME/.profile when install is done."

# SETUP GOPATH

echo "[~] Installing go tools"
echo "----------------------------

echo "[+] Installing gobuster..."
go get github.com/OJ/gobuster

echo "[+] Installing waybackurls..."
go get -u github.com/tomnomnom/waybackurls

echo "[+] Installing httprobe..."
go get -u  go get -u github.com/tomnomnom/httprobe

echo "[+] Installing meg..."
go get -u github.com/tomnomnom/meg

echo "[+] Installing aquatone..."
AQUATONE="aquatone-1.7.0.zip"
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O $AQUATONE
unzip $AQUATONE
mv aquatone /usr/local/bin

echo "[+] Installing gowitness..."
go get -u github.com/sensepost/gowitness

echo "[+] Installing chromedriver to /opt/..."
wget https://chromedriver.storage.googleapis.com/78.0.3904.105/chromedriver_linux64.zip -O chromedriver.zip
unzip chromedriver.zip
mv chromedriver /opt/

echo "[+] Installing massdns..."
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
mv bin/massdns /usr/local/bin

echo "[+] Installing SecLists to /opt/..."
git clone https://github.com/danielmiessler/SecLists.git /opt/seclists

echo "[+] Installing common2speak to /opt/wordlists/..."

echo "----------------------------
echo "[~] Installing python tools"
echo "----------------------------

echo "[+] Installing dnsgen..."
pip install dnsgen
