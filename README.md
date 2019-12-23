# Create F5 BIG-IP VM or General VM
This module is supporting to create F5 BIG-IP VM with landingzone_vdc_demo( https://www.arnaudlheureux.io/2019/11/15/cloud-adoption-framework-landing-zones-with-terraform/ )which is more developped compared to the previous version blueprints_tranquility(https://github.com/aztfmod/blueprints/tree/master/blueprint_tranquility).<br>
This is working as one of its module and also you can use this for your own standalone VM creator after some modify.
You can check the previous version detail from README_v0.md file.
You need to install

# Getting Started
You need to update VM and plan part of the variable.tf file for your environment.<br/>
and add some inforamtion(your own information) to end of the foundations.tf file under landingzone_vdc_demo root diretory.
You can use all of the defaults parameters for your testing after some files updating like blueprint.tf, output.tf under each blueprint_networking directories where you want to add BIG-IP with main module file for F5BIG-IP.

If you want to add BIG-IP into blueprint_networking_shared_egress and blueprint_networking_shared_transit, you need to edit 2 files(blueprint.tf, output.tf) in the each directory and add F5BIGIP_Egress.tf, F5BIGIP_Transit.tf.
Of course, you can use your won module name not use them(F5BIGIP_Egress.tf, F5BIGIP_Transit.tf).

So, let's see example lines for each file.
## blueprint_networking_shared_egress
 - add following lines in blueprint.tf
 
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

 - add following lines in output.tf

## blueprint_networking_shared_transit


## landingzone_vdc_demo
create blueprint_f5bigip directory with below files
 - f5bigip.tf
 
 - main.tf
 
 - output.tf
 
 - variables.tf

  
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
![example](https://github.com/jungcheolkwon/f5-bigip/blob/master/foundations.tf.png)

