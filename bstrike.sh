

############################################
#            BOUNTYSTRIKE-SH               #
#            ~ dubsec|ceph ~               #
############################################


PROJECT=$1
TARGET=$2

NOW=$(date +'%Y-%m-%d_%H-%M-%S')

if [ ! -d "$PROJECT" ]; then
    mkdir $PROJECT
    cd $PROJECT
else
    cd $PROJECT
fi


DOMAINS_FILE="domains-$NOW.txt"

touch $DOMAINS_FILE

# Passively find subdomains
amass enum -passive -o $DOMAINS_FILE -log amass.log -d $TARGET &
subfinder -d $TARGET >> $DOMAINS_FILE &
gobuster dns -d fortnox.se -w /opt/seclists/Discovery/DNS/subdomains-top1million-5000.txt --output gobuster-$DOMAINS_FILE 

cat gobuster-$DOMAINS_FILE >> $DOMAINS_FILE

# Create Master domains file
sort -u $DOMAINS_FILE -o final-domains.txt

# Find domains urls from wayback
cat final-domains.txt | waybackurls > waybackurls.txt

# Maybe wayback has some uniq domains
cat waybackurls.txt | unfurl domains | sort | uniq >> final-domains.txt
sort -u final-domains.txt -o final-domains.txt

# dnsgen
dnsgen final-domains.txt > dnsgen-domains.txt

# Find alive URLs, can reveal old hidden stuff
#nohup okurls() | grep -w -E "200" >> alive-urls.txt

# Find HTTP servers from domains
cat final-domains.txt | httprobe > alive.txt

# Get Screenshots from online domains
cat alive.txt | aquatone -out aquatone &

# Subdomain takeover 

#------------------------------
# Masscan all domains
# nmap scan
#------------------------------


## Stuff to fix
# create functions
# order functions by phase, i.e. asset discovery, content discovery, network discovery, vulnerability discovery
# github, pastebin
# brute force URL paths
# save header respones
# install mullvad, use wireguard
# use nahamsec rootdomains script
# database to store data
# notification for new domains and diffs 
# check for vulnerable javascript files
# call api endpoint on found vuln --> notify via telegram


