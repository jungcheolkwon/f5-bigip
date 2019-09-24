# Create F5 BIG-IP VM or General VM
This module is supporing to create F5 BIG-IP VM with blueprints_tranquility(https://github.com/aztfmod/blueprints/tree/master/blueprint_tranquility).
This is working as one of its module and also you can use this for your own standalone VM creator after some modify.

## Getting Started
You need to update VM and plan part of the variable.tf file for your environment.<br/>
and add some inforamtion to end of the foundations.auto.tfvars/foundations.tf files like following

# virtual network info in foundations.auto.tfvars<br>
#virtual network<br>
shared_services_vnet = {<br>
   region1 = {<br>
     vnet = {<br>
       name                = "sg1vnetdmz"<br>
       address_space       = ["10.101.4.0/22"]<br>
       dns                 = ["192.168.0.16", "192.168.0.64"]<br>
     },<br>
    specialsubnets     = {<br>
      AzureFirewallSubnet = {<br>
        name                = "AzureFirewallSubnet"<br>
        cidr                = "10.101.4.0/25"<br>
        service_endpoints   = []<br>
        }<br>
     },<br>
   subnets = {<br>
     Subnet_4       = {<br>
       name                = "Intranet"<br>
       cidr                = "10.101.5.0/24"<br>
       service_endpoints   = ["Microsoft.EventHub"]<br>
       nsg_inbound         = [<br>
         ["OFFICE", "100", "Inbound", "Allow", "*", "*", "*", "40.60.110.50/32", "*"],<br>
         ["HOME", "110", "Inbound", "Allow", "*", "*", "*", "50.180.140.40/32", "*"],<br>
       ]<br>
       nsg_outbound        = []<br>
      },<br>
     Subnet_6       = {<br>
       name                = "IDS"<br>
       cidr                = "10.101.7.0/24"<br>
       service_endpoints   = ["Microsoft.EventHub"]<br>
       nsg_inbound         = [<br>
         ["OFFICE", "100", "Inbound", "Allow", "*", "*", "*", "42.61.112.56/32", "*"],<br>
       ]<br>
       nsg_outbound        = []<br>
       }<br>
    }<br>
  }<br>
}<br>
![example](https://raw.githubusercontent.com/jungcheolkwon/f5-bigip/master/foundations.auto.tfvars.png)
  
  
# F5 module in foundations.tf
#Create F5 BIGIP VE<br>
module "f5_bigip" {<br>
 source  = "git@github.com:jungcheolkwon/f5bigip.git?ref=v1.75"<br>

 resource_group_name       = module.resource_group_hub.names["HUBTRANSITNET"]<br>
 location                  = var.location_map["region1"]<br>
 tags                      = var.tags_hub<br>
 virtual_network_name      = module.virtual_network["vnet_name"]<br>
 subnet_id                 = module.virtual_network.vnet_subnets["Intranet"]<br>
 network_security_group_id = module.virtual_network.nsg_vnet["Intranet"]<br>
}<br>

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
