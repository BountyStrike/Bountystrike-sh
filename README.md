
# Bountystrike-sh

**Bountystrike-sh** is a collection of bash and python scripts that installs common bug bounty tools, performs recon scans and continous asset discovery.

Bountystrike-sh is opensource but belongs to the BountyStrike project, self-hosted bug bounty management system.

## Tools

The following tools and worldlists will be installed:

* [Amass](https://github.com/OWASP/Amass)
* [Subfinder](https://github.com/projectdiscovery/subfinder)
* [Gobuster](https://github.com/OJ/gobuster)
* [Waybackurls](http://github.com/tomnomnom/waybackurls)
* [httprobe](github.com/tomnomnom/httprobe)
* meg
* unfurl
* gowitness
* GetJS
* Subzy
* SubOver
* Aquatone
* dnsgen
* truffleHog
* googd0rker.py
* massdns
* masscan
* nmap
* SecLists
* Whatweb

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