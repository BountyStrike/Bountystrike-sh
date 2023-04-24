#!/bin/bash

############################################
#            BOUNTYSTRIKE-SH               #
#              ~ dubsec ~                  #
############################################

PROJECT=""
TARGET=""

NOW=$(date +'%Y-%m-%d_%H-%M-%S')
TOOLS_DIR="$HOME/tools"

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"


DOMAINS_FILE="domains-$NOW.txt"
FINAL_DOMAINS="final-domains.txt"

runBanner(){
    name=$1
    echo -e "${GREEN}\n[+] Running $name...${RESET}"
}


##
# Extract URLs and paths from javascript files
##
URLPathExtract() {
    while read u; do
        curl -s $u | grep -Po "(\/)((?:[a-zA-Z\-_\:\.0-9\{\}]+))(\/)*((?:[a-zA-Z\-_\:\.0-9\{\}]+))(\/)((?:[a-zA-Z\-_\/\:\.0-9\{\}]+))" | sort -u | sed 's/^/http:\/\/URL/' >> paths.txt
    done < alive-js-files.txt
}

##
# This function takes a list of IPs and uses amass to find corresponding domain names.
##
IpDomainDiscovery() {
    while read ip; do
        amass intel -rf $TOOLS_DIR/resolvers.txt -ef $FINAL_DOMAINS -timeout 300 -active -addr $ip >> amass-intel.txt
    done < $TARGET_IPS
    cat amass-intel.txt | anew $FINAL_DOMAINS | puredns resolve -q --rate-limit 500 --resolvers $TOOLS_DIR/resolvers.txt | tee -a $FINAL_DOMAINS_RESOLVED | httpx -nc -title -td -sc | tee -a httpx.txt
    sort -u httpx.txt -o httpx.txt
}

subdomainDiscovery() {
    runBanner "Subdomain Discovery with amass and subfinder"
    # Passively find subdomains
    # Kill amass after 120 seconds incase it hangs for some reason
    timeout 300s amass enum -passive -o $DOMAINS_FILE -log amass.log -d $TARGET &
    subfinder -d $TARGET > subfinder-$DOMAINS_FILE &

    echo "[!] Waiting for amass and subfinder to finish..."
    wait

    cat subfinder-$DOMAINS_FILE >> $DOMAINS_FILE

    # Remove files
    rm subfinder-$DOMAINS_FILE

    # run dnsgen only on new domains, skip if file exists.
    if [ ! -s dnsgen-domains.txt ]
    then
        runBanner "dnsgen"
        dnsgen --fast $DOMAINS_FILE > dnsgen-domains.txt
        cat dnsgen-domains.txt | puredns resolve --rate-limit 500 --resolvers $TOOLS_DIR/resolvers.txt | tee -a dnsgen-resolved.txt
        cat dnsgen-resolved.txt >> $DOMAINS_FILE
    else
        echo -e "${RED}[!] Skipping dnsgen since the file has already been generated.${RESET}"
    fi

    sort -u $DOMAINS_FILE -o $DOMAINS_FILE

    if [ -s $FINAL_DOMAINS ]
    then
        comm -23 $DOMAINS_FILE $FINAL_DOMAINS > new-domains-$NOW.txt
        runBanner "dnsgen on new domains"
        dnsgen --fast new-domains-$NOW.txt > dnsgen-new-domains-$NOW.txt
        runBanner "massdns on new generated domains"
        cat dnsgen-new-domains-$NOW.txt | puredns resolve --rate-limit 500 --resolvers $TOOLS_DIR/resolvers.txt >> dnsgen-resolved-new-domains-$NOW.txt
        sort -u $DOMAINS_FILE -o $FINAL_DOMAINS
    else
        # Create Master domains file
        sort -u $DOMAINS_FILE -o $FINAL_DOMAINS
    fi

    runBanner "httpx"
    cat $FINAL_DOMAINS | httpx -title -td -sc >> httpx.txt
    sort -u httpx.txt -o httpx.txt

}

contentDiscovery(){
    runBanner "Gau"
    # Find domains urls from via gau (wayback etc.)
    cat $FINAL_DOMAINS | gau --threads 20 --timeout 3 --retries 2 --blacklist png,jpg,gif,otf,woff,woff2,tif > waybackurls.txt

    # Maybe wayback has some uniq domains
    cat waybackurls.txt | unfurl domains | sort -u | anew $FINAL_DOMAINS > newdomains.temp

    # this could be a one-liner in the above command, but for some reason, puredns hangs if it receives an empty file
    if [ -s newdomains.temp ]; then
        # do alert logic here
        cat newdomains.temp | puredns resolve -q --rate-limit 500 --resolvers $TOOLS_DIR/resolvers.txt >> $FINAL_DOMAINS
    else
        rm newdomains.temp
    fi

    sort -u $FINAL_DOMAINS -o $FINAL_DOMAINS

    # Check URLs, 404 to external domains may be vulnarble to subdomain takeover

    runBanner "GetJS"
    cat httpx.txt | cut -d " " -f1 | getJS --complete --output alive-js-files.txt
    sort -u alive-js-files.txt -o alive-js-files.txt

    runBanner "Extracting paths from js files"
    URLPathExtract

    ## meg
    # find a good wordlist to use for brutforcing with meg

    ## One liner to import whole list of subdomains into Burp suite for automated scanning!
    # cat <file-name> | xargs -I {} -P 20 curl -L -o /dev/null {} -x 127.0.0.1:8080 -k -s
    # use burp proxy to populate burp with urls. Or maybe import files
}

networkDiscovery(){
    mkdir scans
    # Find IP-addresses
    runBanner "Massdns"
    cat $FINAL_DOMAINS | massdns --output S -q -r $TOOLS_DIR/resolvers.txt > scans/massdns-$NOW.txt
    cat scans/massdns-$NOW.txt | grep -w -E A | cut -d " " -f3 > scans/ips-$NOW.txt
   

    if [ -s scans/ips-$NOW.txt ]
    then
        runBanner "Masscan"
        # Find open-ports on ip list
        sudo masscan -iL scans/ips-$NOW.txt --rate 500 -p10000,10243,1025,1026,1029,1030,1033,1034,1036,1038,110,1100,111,1111,113,119,123,135,137,139,143,1433,1434,1521,15567,161,1748,1754,1808,1809,199,20048,2030,2049,21,2100,22,22000,2222,23,25,25565,27900,2869,3128,3268,3269,32768,32843,32844,32846,3306,3339,3366,3372,3389,3573,35826,3632,36581,389,4190,43862,43871,44048,443,4443,4445,445,45295,4555,4559,464,47001,49152,49153,49154,49155,49156,49157,49158,49159,49160,49165,49171,49182,49327,49664,49665,49666,49667,49668,49669,49670,5000,5038,53,5353,5357,54987,55030,55035,55066,55067,55097,55104,55114,55116,55121,55138,55146,55167,55184,5722,5800,58633,587,5900,59010,59195,593,5985,6001,6002,6003,6004,6005,6006,6007,6008,6010,6011,6019,6144,631,636,64327,64337,6532,7411,745,7778,80,82,83,84,85,86,87,8000,8014,808,8080,81,8192,8228,88,8443,8008,8888,9389,9505,993,995 -oX scans/masscan-$NOW.xml

        # This loop makes sure we only scan the ports open for a specific ip
        while read ip; do
            ports=$(grep $ip scans/masscan-$NOW.xml | grep portid | cut -d "\"" -f 10 | sort -n | uniq | paste -sd,)
            if [[ -n $ports ]]; then
                sudo nmap -n -sV $ip -p$ports --open -Pn -oG scans/nmap-$ip.og -vv
            fi
        done < scans/ips-$NOW.txt

        cat scans/*.og | nmapclean > scans/ip-port-$NOW.list

        cat scans/ip-port-$NOW.list| httpx -title -td -sc >> httpx.txt
        sort -u httpx.txt -o httpx.txt

    else
        echo -e "${RED}[-] Skipping Masscan, ips-$NOW.txt was empty or does not exist${RESET}"
    fi
}

visualDiscovery(){
    # Get Screenshots from online domains
    runBanner "gowitness"
    cat httpx.txt | cut -d " " -f1 | gowitness file -f - 
}

vulnerabilityDiscovery(){
    runBanner "Nuclei"
    cat httpx.txt | cut -d " " -f1 | nuclei -as -rl 20 -o nuclei-$NOW.txt
}


# ------------------------------------------------------------------------- #

help() {

    echo -e "${GREEN}  ____   ____  _    _ _   _ _________     _______ _______ _____  _____ _  ________";
    echo " |  _ \ / __ \| |  | | \ | |__   __\ \   / / ____|__   __|  __ \|_   _| |/ /  ____|";
    echo " | |_) | |  | | |  | |  \| |  | |   \ \_/ / (___    | |  | |__) | | | | ' /| |__   ";
    echo " |  _ <| |  | | |  | | . \` |  | |    \   / \___ \   | |  |  _  /  | | |  < |  __|  ";
    echo " | |_) | |__| | |__| | |\  |  | |     | |  ____) |  | |  | | \ \ _| |_| . \| |____ ";
    echo " |____/ \____/ \____/|_| \_|  |_|     |_| |_____/   |_|  |_|  \_\_____|_|\_\______|";
    echo -e "                                                                                   ${RESET}";
    echo -e "________________________________ ${RED}WHAT THE SHELL?${RESET}__________________________________ ";


	echo -e """
${YELLOW}== Info${RESET}
 Bountystrike-sh is a simple bash pipeline script
 containing a bunch tools piping data between each other.
 No need for any fancy setup ^_^

 Stiched together by ${BLUE}@dubs3c${RESET}.

${YELLOW}== Usage${RESET}:
	bstrike.sh <action> [project] [domain]
	    bstrike.sh install                       (Install tooling)
	    bstrike.sh run fra fra.se                (Run pipeline)
	    bstrike.sh [assetdiscovery|ad]   fra.se  (Run only asset discovery)
	    bstrike.sh [contentdiscovery|cd] fra.se  (Run only content discovery)
	    bstrike.sh [networkdiscovery|nd] fra.se  (Run only network discovery)
	    bstrike.sh [visualdiscovery|vd]  fra.se  (Run only visual discovery)
	    bstrike.sh [vulndiscovery|vvd]   fra.se  (Run only vulnerability discovery)
	"""
	exit 1
}


# main()
# ======================
if [[ $1 == "" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
	help
elif [[ $1 == "install" ]]; then

    bash install.sh

elif [[ $1 == "run" ]]; then

	if [[ ! $2 == "" ]]; then
        PROJECT=$2
        if [ ! -d "$PROJECT" ]; then
            mkdir $PROJECT
            cd $PROJECT
        else
            cd $PROJECT
        fi

        if [[ $3 == "" ]]; then
            echo "[-] Please specify a domain..."
            help
        fi

        TARGET=$3

        # Run pipeline
        # ==============================
        subdomainDiscovery
        contentDiscovery
        networkDiscovery
        vulnerabilityDiscovery
        visualDiscovery

	else
		help
	fi
elif [[ $1 == "assetdiscovery" ]] || [[ $1 == "ad" ]]; then
        if [[ ! $2 == "" ]]; then
            echo -e "\n${GREEN}[+] Running asset discovery on $2...${RESET}"
            echo -e "${GREEN}==============================================================${RESET}"
            TARGET=$2
            subdomainDiscovery
        else
            help
        fi
elif [[ $1 == "contentdiscovery" ]] || [[ $1 == "cd" ]]; then
        if [[ ! $2 == "" ]]; then
            echo -e "\n${GREEN}[+] Running content discovery on $2...${RESET}"
            echo -e "${GREEN}==============================================================${RESET}"
            TARGET=$2
            contentDiscovery
        else
            help
        fi
elif [[ $1 == "networkdiscovery" ]] || [[ $1 == "nd" ]]; then
        if [[ ! $2 == "" ]]; then
            echo -e "\n${GREEN}[+] Running network discovery on $2...${RESET}"
            echo -e "${GREEN}==============================================================${RESET}"
            TARGET=$2
            networkDiscovery
        else
            help
        fi
elif [[ $1 == "vulndiscovery" ]] || [[ $1 == "vvd" ]]; then
        if [[ ! $2 == "" ]]; then
            echo -e "\n${GREEN}[+] Running vulnerability discovery on $2...${RESET}"
            echo -e "${GREEN}==============================================================${RESET}"
            TARGET=$2
            vulnerabilityDiscovery
        else
            help
        fi
elif [[ $1 == "visualdiscovery" ]] || [[ $1 == "vd" ]]; then
        if [[ ! $2 == "" ]]; then
            echo -e "\n${GREEN}[+] Running visual discovery on $2...${RESET}"
            echo -e "${GREEN}==============================================================${RESET}"
            TARGET=$2
            visualDiscovery
        else
            help
        fi
else
    help
fi

echo -e "${GREEN}\n==== BountyStrike surface scan complete ====${RESET}"

