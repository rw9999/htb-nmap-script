#! /bin/bash

ip="${1}"
portL=""

read -p "Enter file name: " filename
echo "Scanning open TCP ports"
nmap -p- -T5  $ip | tee -a "$filename"  

while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                portL="${portL}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open TCP ports"

nmap -p $portL -sC -sV $ip

portL=""

echo "Scanning open UDP ports"

nmap -T5 -sU $ip | tee -a "$filename"

while read line
do
        if [[ ${line:0:1} =~ [0-9] ]]
        then
                portL="${portL}${line%%/*},"
        fi

done < "$filename"

echo "Scanning protocols and versions on open UDP ports"
nmap -p $portL -sU -sC -sV $ip
