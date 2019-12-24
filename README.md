# Create F5 BIG-IP VM or General VM
This module is supporting to create F5 BIG-IP VM with landingzone_vdc_demo( https://www.arnaudlheureux.io/2019/11/15/cloud-adoption-framework-landing-zones-with-terraform/ )which is more developped compared to the previous version blueprints_tranquility(https://github.com/aztfmod/blueprints/tree/master/blueprint_tranquility). <br>
This is working as one of its module and also you can use this for your own standalone VM creator after some modify.
You can check the previous version detail from README_v0.md file.<br>
You need to follow the above guide ( https://www.arnaudlheureux.io/2019/11/15/cloud-adoption-framework-landing-zones-with-terraform/ ) to easy success this demo.

# Getting Started
You need to update VM and plan part of the variable.tf file for your environment. <br>
and add some inforamtion(your own information) to end of the foundations.tf file under landingzone_vdc_demo root diretory. <br>
You can use all of the defaults parameters for your testing after some files updating like blueprint.tf, output.tf under each blueprint_networking directories where you want to add BIG-IP with main module file for F5BIG-IP.

If you want to add BIG-IP into blueprint_networking_shared_egress and blueprint_networking_shared_transit, <br>you need to edit 2 files (blueprint.tf, output.tf) in the each directory and add F5BIGIP_Egress.tf, F5BIGIP_Transit.tf in landingzone_vdc_demo directory.<br>
Of course, you can use your won module's name not use them(F5BIGIP_Egress.tf, F5BIGIP_Transit.tf).

So, let's see example lines for each file.(you can copy and paste all lines from ##start of testing to ##end of testing for each file) <br>
## blueprint_networking_shared_egress
 - add following lines in blueprint.tf
 
```
 ##start of testing <br>
  module "networking_shared_egress_vnet_vnet_nsg" { <br>
    source  = "aztfmod/caf-virtual-network/azurerm" <br>
    version = "0.2.0" <br>

    virtual_network_rg                = local.HUB-EGRESS-NET <br>
    prefix                            = var.prefix <br>
    location                          = var.location <br>
    networking_object                 = var.networking_object <br>
    tags                              = local.tags <br>
    diagnostics_map                   = var.diagnostics_map <br>
    log_analytics_workspace           = var.log_analytics_workspace <br>
    diagnostics_settings              = var.networking_object.diagnostics <br>
  } <br>
   <br>
  module "networking_shared_egress_vnet_vnet_subnets" { <br>
    source  = "aztfmod/caf-virtual-network/azurerm" <br>
    version = "0.2.0" <br>

    virtual_network_rg                = local.HUB-EGRESS-NET <br>
    prefix                            = var.prefix <br>
    networking_object                 = var.networking_object <br>
    tags                  = local.tags <br>
    location              = var.location <br>
    diagnostics_map                   = var.diagnostics_map <br>
    log_analytics_workspace           = var.log_analytics_workspace <br>
    diagnostics_settings              = var.networking_object.diagnostics <br>
  } <br>
  ##end of testing <br>
```

 - add following lines in output.tf

  ##start of testing <br>
  output "resource_group" { <br>
      value       = module.resource_group.names <br>
  } <br>
  
  output "networking_shared_egress_vnet_vnet_nsg" { <br>
      value       = module.networking_shared_egress_vnet.nsg_vnet <br>
  } <br>
  
  output "networking_shared_egress_vnet_vnet_subnets" { <br>
      value       = module.networking_shared_egress_vnet.vnet_subnets <br>
  } <br>
  ##end of testing <br>


## blueprint_networking_shared_transit
 - blueprint.tf

  ##start of jc testing <br>
  module "networking_transit_vnet_vnet_nsg" { <br>
    source  = "aztfmod/caf-virtual-network/azurerm" <br>
    version = "0.2.0" <br>

    virtual_network_rg                = local.HUB-NET-TRANSIT <br>
    prefix                            = var.prefix <br>
    location                          = var.location <br>
    networking_object                 = var.networking_object <br>
    tags                              = local.tags <br>
    diagnostics_map                   = var.diagnostics_map <br>
    log_analytics_workspace           = var.log_analytics_workspace <br>
    diagnostics_settings              = var.networking_object.diagnostics <br>
  } <br>

  module "networking_transit_vnet_vnet_subnets" { <br>
    source  = "aztfmod/caf-virtual-network/azurerm" <br>
    version = "0.2.0" <br>

    virtual_network_rg                = local.HUB-NET-TRANSIT <br>
    prefix                            = var.prefix <br>
    networking_object                 = var.networking_object <br>
    tags                  = local.tags <br>
    location              = var.location <br>
    diagnostics_map                   = var.diagnostics_map <br>
    log_analytics_workspace           = var.log_analytics_workspace <br>
    diagnostics_settings              = var.networking_object.diagnostics <br>
  } <br>
  ##end of testing <br>

 - output.tf

  ##start of testing <br>
  output "resource_group" { <br>
      value       = module.resource_group.names <br>
  } <br>
  
  output "networking_transit_vnet_vnet_nsg" { <br>
      value       = module.networking_transit_vnet.nsg_vnet <br>
  } <br>
 
  output "networking_transit_vnet_vnet_subnets" { <br>
      value       = module.networking_transit_vnet.vnet_subnets <br>
  } <br>
  ##end of testing <br>


## F5 modules under landingzone_vdc_demo
 - F5BIGIP_Egress.tf <br>

  ##start of testing <br>
  module "f5bigip-egress" { <br>
    source  = "git@github.com:jungcheolkwon/f5-bigip.git?ref=v0.1" <br>
    
    resource_group_name       = module.blueprint_networking_shared_egress.resource_group["HUB-EGRESS-NET"] <br>
    location                  = var.location_map["region1"] <br>
    tags                      = module.blueprint_foundations.tags <br>
    virtual_network_name      = var.networking_transit.vnet.name <br>
    subnet_id                 = module.blueprint_networking_shared_egress.networking_shared_egress_vnet_vnet_subnets["Network_Monitoring"] <br>
    network_security_group_id = module.blueprint_networking_shared_egress.networking_shared_egress_vnet_vnet_nsg["Network_Monitoring"] <br>
  } <br>
  ##end of testing <br>
  
   - F5BIGIP_Egress.tf <br>
  
  ##start of testing <br>
  module "f5bigip" { <br>
    source  = "git@github.com:jungcheolkwon/f5-bigip.git?ref=v0.1" <br>
   
    resource_group_name       = module.blueprint_networking_shared_transit.resource_group["HUB-NET-TRANSIT"] <br>
    location                  = var.location_map["region1"] <br>
    tags                      = module.blueprint_foundations.tags <br>
    virtual_network_name      = var.networking_transit.vnet.name <br>
    subnet_id                 = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_subnets["NetworkMonitoring"] <br>
    network_security_group_id = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_nsg["NetworkMonitoring"] <br>
  } <br>
  ##end of testing <br>

# ** you need to add your own public ssh-key in the container where ~/.ssh/id_rsa.pub 
