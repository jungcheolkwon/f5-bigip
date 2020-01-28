module "f5bigip" {
#  source  = "git://github.com/jungcheolkwon/f5-bigip.git?ref=v0.1"
  source  = "./blueprint_f5bigip_transit"

resource_group_name       = module.blueprint_networking_shared_transit.resource_group["HUB-NET-TRANSIT"]
location                  = var.location_map["region1"]
tags                      = module.blueprint_foundations.tags
virtual_network_name      = var.networking_transit.vnet.name
subnet_id                 = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_subnets["NetworkMonitoring"]
network_security_group_id = module.blueprint_networking_shared_transit.networking_transit_vnet_vnet_nsg["NetworkMonitoring"]
}
