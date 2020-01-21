
# Bountystrike-sh

**Still in alpha stage**

**Bountystrike-sh** is a collection of bash and python scripts that installs common bug bounty tools, performs recon scans and continous asset discovery.

Bountystrike-sh is opensource but belongs to the BountyStrike project, self-hosted bug bounty management system.

```
  ____   ____  _    _ _   _ _________     _______ _______ _____  _____ _  ________
 |  _ \ / __ \| |  | | \ | |__   __\ \   / / ____|__   __|  __ \|_   _| |/ /  ____|
 | |_) | |  | | |  | |  \| |  | |   \ \_/ / (___    | |  | |__) | | | | ' /| |__
 |  _ <| |  | | |  | | . ` |  | |    \   / \___ \   | |  |  _  /  | | |  < |  __|
 | |_) | |__| | |__| | |\  |  | |     | |  ____) |  | |  | | \ \ _| |_| . \| |____
 |____/ \____/ \____/|_| \_|  |_|     |_| |_____/   |_|  |_|  \_\_____|_|\_\______|

________________________________ WHAT THE SHELL?__________________________________

== Info
 Bountystrike-sh is a simple bash pipeline script
 containing a bunch tools piping data between each other.
 No need for any fancy setup ^_^

 Stiched together by @dubs3c.

== Usage:
        bstrike.sh <action> [project] [domain]
            bstrike.sh install                       (Install tooling)
            bstrike.sh run fra fra.se                (Run pipeline)
            bstrike.sh [assetdiscovery|ad]   fra.se  (Run only asset discovery)
            bstrike.sh [contentdiscovery|cd] fra.se  (Run only content discovery)
            bstrike.sh [networkdiscovery|nd] fra.se  (Run only network discovery)
            bstrike.sh [visualdiscovery|vd]  fra.se  (Run only visual discovery)
            bstrike.sh [vulndiscovery|vvd]   fra.se  (Run only vulnerability discovery)
```

## Tools

The following tools and worldlists will be installed:

* [Amass](https://github.com/OWASP/Amass)
* [Subfinder](https://github.com/projectdiscovery/subfinder)
* [Gobuster](https://github.com/OJ/gobuster)
* [Waybackurls](http://github.com/tomnomnom/waybackurls)
* [WaybackUnifier](https://github.com/mhmdiaa/waybackunifier)
* [httprobe](github.com/tomnomnom/httprobe)
* [meg](https://github.com/tomnomnom/meg)
* [unfurl](https://github.com/tomnomnom/unfurl)
* [filter-resolved](https://github.com/tomnomnom/hacks/tree/master/filter-resolved)
* [gowitness](https://github.com/sensepost/gowitness)
* [GetJS](https://github.com/003random/getJS)
* [Subzy](https://github.com/lukasikic/subzy)
* [SubOver](https://github.com/Ice3man543/SubOver)
* [Aquatone](https://github.com/michenriksen/aquatone)
* [gitrob](https://github.com/michenriksen/gitrob)
* [dnsgen](https://github.com/ProjectAnte/dnsgen)
* [truffleHog](https://github.com/dxa4481/truffleHog)
* [massdns](https://github.com/blechschmidt/massdns)
* [masscan](https://github.com/robertdavidgraham/masscan)
* [nmap](https://github.com/nmap/nmap)
* [SecLists](https://github.com/danielmiessler/SecLists)
* [sshgit](https://github.com/eth0izzle/shhgit)
* [api_wordlist](https://github.com/chrislockard/api_wordlist)

Other stuff that will be installed as well:
* Python 3.7.6
* NodeJS
* npm
* Docker CE
* Ruby

## Install
Just run `bash install.sh` to get the bug hunting environment. So far only tested for Ubuntu 18.01.

### Vagrant
You also the have the option to use vagrant with virtualbox, just runt `vagrant up && vagrant ssh`. Create a folder called `data` in the root directory, vagrant will map it to `/vagrant_data` inside the VM.

## Running
Simply run `./bstrike.sh <project> <domain>`. 


## Contributing
Any feedback or ideas are welcome! Want to improve something? Create a pull request!

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Configure pre commit checks: `pre-commit install`
4. Commit your changes: `git commit -am 'Add some feature'`
5. Push to the branch: `git push origin my-new-feature`
6. Submit a pull request :D
