# NARS-Nmap-Automated-Recon-Script 
NARS is a shell script that helps automate nmap scanning of local networks and devices.

## Dependencies
1. bash 4+
2. nmap 7+

## How to Run the Script
Make sure Nmap is installed. You can check by using typing `nmap -v` in the terminal. If it is not installed, use your OS's package manager to install. On Ubuntu 18.04, for example, `sudo apt install nmap`. 

It's recommended to run the command as root if network discovery feature is in use.
```
$ sudo bash NARS.sh
```
* After executing the command answer the guided prompts:
  * Enter the device ip: {Enter a IP}
  * Enter Output filename: {Enter a filename}
  * Enable Network Device Discovery Y/n?
    * The network Device Discovery mode allows for a whole network scan of all device. This feature uses the base ip provided and will scan the subnet provided in a later prompt.
  * Use Nmap Vulnerability Scanners? 'Y/n' or 'V' for verbose test: {Y/n or v}
    * The vuln option will scan the target device for vulnerabilities. If select 'y' to this option and the network device discovery you will able to pentest all devices found on a selected network. This is completely optional, you will be asked after this prompt (if selected yes to Enable Network Device Discovery) to just do the network device discovery or network device discovery and pentesting. 
  * If yes was selected for Enable Network Device Discovery:
    * Enter a Subnet for 'Network Device Discovery' Option: {enter a subnet to be scanned for device} 
    * Run Nmap Scanners for ALL found devices? Y/n:  
      * This option will allow you to vuln test all devices if the 'Use Nmap Vulnerability Scanners' option was selected or you can do normal scans if the options wasnt selected. If you wish to just scan the original devices and see whats on the network, just enter a 'n'. 
