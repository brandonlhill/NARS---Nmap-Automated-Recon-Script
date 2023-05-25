# Cloned from: https://github.com/brandonlhill/Nmap-Automated-Recon-Script 
# Built Date: 11/03/2019. Updated: 12/15/2019. Version 1.2.1
# This tool puts together a collection of important nmap scanning features.
# This tool was built for educational purposes only. 
# Do not use this tool to scan devices without the proper permission

# NARS - Nmap Automated Recon Script.
Red='\033[0;31m'
Green='\033[0;32m'
Darkgray='\033[1;30m'
NC='\033[0m'

printf "${Red}Welcome to NARS - Nmap Automated Recon Script${NC}\n\n"
read -p "Please Enter Device IP: " IP
read -p "Enter Output Filename: " fileName
read -p "Enable Network Device Discovery? Y/n: " networkDiscovery
read -p "Use Nmap Vulnerability Scanners? 'Y/n' or 'V' for verbose test: " vulnOption
read -p "Use -Pn flag? Y/n: " pn

# Parsing User Options.
# -Pn Option:
if [ "${pn^^}" == "Y" ] || [ -z "$pn" ]
then
  pn="-Pn"
else
  pn=""
fi

# Vulnerability Scanners Option:
if [ "${vulnOption^^}" == "Y" ] || [ -z "$vulnOption" ]
then
  vulnOption=",vuln,http-enum,smb-system-info --version-intensity 5" 
elif [ "${vulnOption^^}" == "V" ]
then
  vulnOption=",vuln,dos,http-enum,smb-brute,ssl-heartbleed,http-sql-injection,http-slowloris,smb-system-info --version-intensity 5" #other options ssh-brute,smb-enum-users
else
  vulnOption=""
fi

# Main Nmap command.
main(){
  echo -e "---------------------------------- New Scan ----------------------------------" >> $fileName".NARS-recon"  
  nmap $pn -A -T4 -p 1-65535 -sV --stats-every 10s --script=banner,http-title,smb-os-discovery$vulnOption --append-output -oN $fileName".NARS-recon" $1 #--webxml openable web-script output, -oS for interactive output. 
}

# Main If-statement
if [ "${networkDiscovery^^}" == "Y" ] || [ -z "$networkDiscovery"]
then
  printf "${Darkgray}The Network Device Discovery option will take the current IP and use selected subnet rules to scan all devices with in that subnet.\nExample: Selecting IP 192.168.12.1 and subnet /24 will make the script scan everything from 192.168.12.1 to 192.168.12.255.${NC}\n\n"
  read -p "Enter a Subnet for 'Network Device Discovery' Option: " subnet
  read -p "Run Nmap Scanners for ALL found devices? Y/n: " scanAll
  subnet=`echo $subnet | tr --delete /`
  printf "${Green}Scanning $IP Subnet Range ($subnet) for Devices${NC}\n" 
  # Nmap scanner for devices on network range.
  nmap -sn -Pn $IP/$subnet | grep report | sed 's/Nmap scan report for//g' | grep "(" | tee $fileName".NARS-devices" # tee -a appends to a file.
  if ([ "${scanAll}" == "Y"  ] || [ -z "$scanAll" ]) && [ -s $fileName".NARS-devices" ] # If scanAll was selected by user, and if devices file contains IP's run the following:.
  then 
    while IFS= read -r item
    do
      let counter=counter+1 
      device=`sed $counter"q;d" $fileName.NARS-devices | cut -d "(" -f2 | cut -d ")" -f1`
      printf "${Green}Nmap Scanning Device: $device ${NC}\n"
      main $device #calling main function
    done < $fileName".NARS-devices"
  else # defaults to scanning single IP provided.
    printf "${Green}Scan Started${NC}\n"
    main $IP
  fi
else
  printf "${Green}Scan Started${NC}\n"
  main $IP # defaults to scanning single IP provided. 
fi
#reverse DNS-Lookup:
#nmap -sL or -n target
