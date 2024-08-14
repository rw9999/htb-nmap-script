#! /bin/bash

if [ -z "$1" ]; then
        echo "Please provide ip address"
        exit 1
fi

ip="${1}"
tcpPorts=""
udpPorts=""

read -p "Enter file name: " filename

> "$filename"

echo "Scanning open TCP ports"

nmap -p- -T5  $ip | tee -a "$filename"  

while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                tcpPorts="${tcpPorts}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open TCP ports"

nmap -p $tcpPorts -sC -sV $ip

echo "Scanning open UDP ports"

nmap -T5 -sU $ip | tee -a "$filename"

while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                udpPorts="${udpPorts}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open UDP ports"
nmap -p $udpPorts -sU -sC -sV $ip
