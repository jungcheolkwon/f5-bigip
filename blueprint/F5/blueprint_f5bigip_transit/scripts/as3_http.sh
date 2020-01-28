#!/bin/bash

#https://github.com/F5Networks/terraform-provider-bigip/tree/master/examples/as3
#https://clouddocs.f5.com/products/big-iq/mgmt-api/v6.0/HowToSamples/bigiq_public_api_wf/t_bigiq_public_api_workflows.html
#https://clouddocs.f5.com/products/big-iq/mgmt-api/v6.0/ApiReferences/bigiq_public_api_ref/r_ip_pool_state.html

#if [ -z "$1" ]; then
#    echo "The prefix of RG is required for process!."
#    exit 0
#fi

prefix="$(cat new_prefix)"
#prefix=$1
name="$(cat ~/.ssh/.user)"
password="$(cat ~/.ssh/.password)"

rg=$prefix-hub-network-transit
ip=$(az vm show -d -g $rg -n bigip1-0 --query publicIps -o tsv)

token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$ip:8443/mgmt/shared/authn/login | jq -r .token.token)

echo -e "\033[1m...Deploying HTTP Virtual Server and Pools ....... \033[0m "
curl -k -H "Content-Type: test/x-yaml" -H "X-F5-Auth-Token: $token" -X POST --data-binary @as3.json https://$ip:8443/mgmt/shared/appsvcs/declare | jq -r .
