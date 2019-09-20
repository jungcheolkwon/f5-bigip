# Create F5 BIG-IP VM or General VM
This module is supporing to create F5 BIG-IP VM with blueprints_tranquility(https://github.com/aztfmod/blueprints/tree/master/blueprint_tranquility).
This is working as one of its module and also you can use this for your own standalone VM creator after some modify.

## Getting Started
You need to update VM and plan part of the variable.tf file for your environment.<br/>
and add some inforamtion to end of the foundations.auto.tfvars/foundations.tf files like following

 - virtual network info in foundations.auto.tfvars
 - #virtual network
 - shared_services_vnet = {
 - region1 = {
 -   vnet = {
 -     name                = "sg1-vnet-dmz"
 -     address_space       = ["10.101.4.0/22"]
 -     dns                 = ["192.168.0.16", "192.168.0.64"]
 - },
 -  specialsubnets     = {
 -    AzureFirewallSubnet = {
 -      name                = "AzureFirewallSubnet"
 -      cidr                = "10.101.4.0/25"
 -      service_endpoints   = []
 -    }
 -  },
 - subnets = {
 -   Subnet_4       = {
 -     name                = "Intranet"
 -     cidr                = "10.101.5.0/24"
 -     service_endpoints   = ["Microsoft.EventHub"]
 -     nsg_inbound         = [
 -       ["OFFICE", "100", "Inbound", "Allow", "*", "*", "*", "40.60.110.50/32", "*"],
 -       ["HOME", "110", "Inbound", "Allow", "*", "*", "*", "50.180.140.40/32", "*"],
 -     ]
 -     nsg_outbound        = []
 -   },
 -   Subnet_6       = {
 -     name                = "IDS"
 -     cidr                = "10.101.7.0/24"
 -     service_endpoints   = ["Microsoft.EventHub"]
 -     nsg_inbound         = [
 -       ["OFFICE", "100", "Inbound", "Allow", "*", "*", "*", "42.61.112.56/32", "*"],
 -     ]
 -     nsg_outbound        = []
 -   }
 - }
 - }
 - }

  - F5 module in foundations.tf
-  # Create F5 BIG-IP VE
- module "f5_bigip" {
-  source  = "git@github.com:jungcheolkwon/f5-bigip.git?ref=v1.75"

-  resource_group_name       = module.resource_group_hub.names["HUB-TRANSIT-NET"]
-  location                  = var.location_map["region1"]
-  tags                      = var.tags_hub
-  virtual_network_name      = module.virtual_network["vnet_name"]
-  subnet_id                 = module.virtual_network.vnet_subnets["Intranet"]
-  network_security_group_id = module.virtual_network.nsg_vnet["Intranet"]
- }

## Capabilities

 - Resource groups
    - Core resource groups needed for hub-spoke topology.
 - Activity Logging
    - Auditing all subscription activities and archiving
        - Storage Account
        - Event Hubs

## Customization
The provided foundations.auto.tfvars allows you to deploy your first version of blueprint_tranquility and see the typical options

## Foundations
Please do not modify the provided output variables but add additionnal below if you need to extend the model.



## Contribute
Pull requests are welcome to evolve the framework and integrate new features!
