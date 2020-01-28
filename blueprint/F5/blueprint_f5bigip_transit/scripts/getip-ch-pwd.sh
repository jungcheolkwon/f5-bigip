#!/bin/bash

#edited by JC
#j.kwon@f5.com

#az network public-ip list -g zpel-hub-network-transit | jq -r .[].ipAddress  > public
#sed -i -e "1d" public

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
	#az vm show -d -g JCK_SG -n Azure-Master --query privateIps --out tsv
	#ip=$(az vm show -d -g jflh-hub-network-transit -n $i --query publicIps -o tsv)
	ip=$(az vm show -d -g $rg -n $i --query publicIps -o tsv)
	echo "$ip"
	./ch_pwd.sh $ip
  else
	ip=$(az vm show -d -g $rg -n $i --query publicIps -o tsv)
	echo "$i"
	echo "$ip"
	./ch_pwd2.sh $ip
fi
done
