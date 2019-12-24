# Create F5 BIG-IP VM or General VM
This module is supporting to create F5 BIG-IP VM with landingzone_vdc_demo( https://www.arnaudlheureux.io/2019/11/15/cloud-adoption-framework-landing-zones-with-terraform/ )which is more developped compared to the previous version blueprints_tranquility(https://github.com/aztfmod/blueprints/tree/master/blueprint_tranquility). <br>
This is working as one of its module and also you can use this for your own standalone VM creator after some modify.
You can check the previous version detail from README_v0.md file.<br>
You need to follow the above guide ( https://www.arnaudlheureux.io/2019/11/15/cloud-adoption-framework-landing-zones-with-terraform/ ) to easy success this demo.

# Getting Started
You need to update VM and plan part of the variable.tf(https://github.com/jungcheolkwon/f5-bigip/blob/master/variables.tf) file for your environment. <br>
and add some inforamtion(your own information) to end of the foundations.tf file under landingzone_vdc_demo root diretory. <br>
If you don't modify F5 module file, the bigip source will be came from github and I recommend you that source file clone in local container like blueprint_f5bigip from my demo.<br>
You can use all of the defaults parameters for your testing after some files updating like blueprint.tf, output.tf under each blueprint_networking directories where you want to add BIG-IP with main module file for F5BIG-IP.

If you want to add BIG-IP into blueprint_networking_shared_egress and blueprint_networking_shared_transit, <br>you need to edit 2 files (blueprint.tf, output.tf) in the each directory and add F5BIGIP_Egress.tf, F5BIGIP_Transit.tf in landingzone_vdc_demo directory.<br>
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/vsc_container.png)
Of course, you can use your won module's name not use them(F5BIGIP_Egress.tf, F5BIGIP_Transit.tf).<br>
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/f5bigip_transit.png)
If you want to add NSG rules, you need to edit the blueprint_networking_shared_egress.sandpit.auto.tfvars or blueprint_networking_shared_transit.sandpit.auto.tfvars
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/nsg_rules.png)

So, let's see example lines for each file.(you can copy and paste all lines from ##start of testing to ##end of testing for each file) <br>
## blueprint_networking_shared_egress
 - add following lines in blueprint.tf
 
```
 ##start of testing
  module "networking_shared_egress_vnet_vnet_nsg" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.2.0"

    virtual_network_rg                = local.HUB-EGRESS-NET
    prefix                            = var.prefix
    location                          = var.location
    networking_object                 = var.networking_object
    tags                              = local.tags
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
    diagnostics_settings              = var.networking_object.diagnostics
  }
  
  module "networking_shared_egress_vnet_vnet_subnets" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.2.0"

    virtual_network_rg                = local.HUB-EGRESS-NET
    prefix                            = var.prefix
    networking_object                 = var.networking_object
    tags                  = local.tags
    location              = var.location
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
    diagnostics_settings              = var.networking_object.diagnostics
  }
  ##end of testing
```

 - add following lines in output.tf
```
  ##start of testing
  output "resource_group" {
      value       = module.resource_group.names
  }
  
  output "networking_shared_egress_vnet_vnet_nsg" {
      value       = module.networking_shared_egress_vnet.nsg_vnet
  }
  
  output "networking_shared_egress_vnet_vnet_subnets" {
      value       = module.networking_shared_egress_vnet.vnet_subnets
  }
  ##end of testing
```

## blueprint_networking_shared_transit
 - blueprint.tf
```
  ##start of jc testing
  module "networking_transit_vnet_vnet_nsg" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.2.0"

    virtual_network_rg                = local.HUB-NET-TRANSIT
    prefix                            = var.prefix
    location                          = var.location
    networking_object                 = var.networking_object
    tags                              = local.tags
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
    diagnostics_settings              = var.networking_object.diagnostics
  }

  module "networking_transit_vnet_vnet_subnets" {
    source  = "aztfmod/caf-virtual-network/azurerm"
    version = "0.2.0"

    virtual_network_rg                = local.HUB-NET-TRANSIT
    prefix                            = var.prefix
    networking_object                 = var.networking_object
    tags                  = local.tags
    location              = var.location
    diagnostics_map                   = var.diagnostics_map
    log_analytics_workspace           = var.log_analytics_workspace
    diagnostics_settings              = var.networking_object.diagnostics
  }
  ##end of testing
```

 - output.tf
```
  ##start of testing
  output "resource_group" {
      value       = module.resource_group.names
  }
  
  output "networking_transit_vnet_vnet_nsg" {
      value       = module.networking_transit_vnet.nsg_vnet
  }
 
  output "networking_transit_vnet_vnet_subnets" {
      value       = module.networking_transit_vnet.vnet_subnets
  }
  ##end of testing
```

## F5 modules under landingzone_vdc_demo
 - F5BIGIP_Egress.tf
```
  ##start of testing
  module "f5bigip-egress" {
    source  = "git@github.com:jungcheolkwon/f5-bigip.git?ref=v0.1"
    #source  = "./blueprint_f5bigip"
    
    resource_group_name       = module.blueprint_networking_shared_egress.resource_group["HUB-EGRESS-NET"]
    location                  = var.location_map["region1"]
    tags                      = module.blueprint_foundations.tags
    virtual_network_name      = var.networking_transit.vnet.name
    subnet_id                 = module.blueprint_networking_shared_egress.networking_shared_egress_vnet_vnet_subnets["Network_Monitoring"]
    network_security_group_id = module.blueprint_networking_shared_egress.networking_shared_egress_vnet_vnet_nsg["Network_Monitoring"]
  }
  ##end of testing
 ``` 

   - F5BIGIP_Egress.tf
```  
  ##start of testing
  module "f5bigip" {
    source  = "git@github.com:jungcheolkwon/f5-bigip.git?ref=v0.1"
    #source  = "./blueprint_f5bigip"
   
    resource_group_name       = module.blueprint_networking_shared_transit.resource_group["HUB-NET-TRANSIT"]
    location                  = var.location_map["region1"]
    tags                      = module.blueprint_foundations.tags
    virtual_network_name      = var.networking_transit.vnet.name
    subnet_id                 = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_subnets["NetworkMonitoring"]
    network_security_group_id = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_nsg["NetworkMonitoring"]
  }
  ##end of testing
```
###  you need to add your own public ssh-key in the container where ~/.ssh/id_rsa.pub 

Now,let us run rover to build new VDC
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/run_plan.png)

![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/ran_plan.png)

then reload/check Azure portal what was happened
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/images/check_portal1.png)
