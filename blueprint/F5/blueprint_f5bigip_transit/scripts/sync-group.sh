#!/bin/bash

#edited by JC
#j.kwon@f5.com

#if [ -z "$1" ]; then
#    echo "The prefix of RG is required for process!."
#    exit 0
#fi

prefix="$(cat new_prefix)"
#prefix=$1
rg=$prefix-hub-network-transit

for i in bigip1-0 bigip2-0
do 
  if [ $i == "bigip1-0" ]
  then
	ip=$(az vm show -d -g $rg -n $i --query publicIps -o tsv)
    ./sync1.sh "$ip"
    sed -i -e 's#https://[0-9].*:8443#https://'$ip':8443#g' as3_http.sh
  else
	ip=$(az vm show -d -g $rg -n $i --query publicIps -o tsv)
    ./sync2.sh "$ip"
fi
done