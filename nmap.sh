#! /bin/bash

#checks if ip was enter in cli
if [ -z "$1" ]; then
        echo "Please provide ip address"
        exit 1
fi

#puts it into ip variable
ip="${1}"
tcpPorts=""
udpPorts=""

#asks for file name
read -p "Enter file name: " filename

#creates file or overwrites if is exists
> "$filename"

echo "Scanning open TCP ports"

# nmap scans all open ports/should be fast/verbose output while putting it in the file
nmap -p- --min-rate=2000  $ip | tee -a "$filename"  

#parses open ports
while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                tcpPorts="${tcpPorts}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open TCP ports"

#does udp ports
nmap -p $tcpPorts -sC -sV $ip | tee -a "$filename"  

echo "Scanning open UDP ports"

nmap --min-rate=1000 -sU $ip | tee -a "$filename"

while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                udpPorts="${udpPorts}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open UDP ports"
nmap -p $udpPorts -sU -sC -sV $ip | tee -a "$filename"  
