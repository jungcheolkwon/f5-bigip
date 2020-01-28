#https://github.com/Azure/terraform-azurerm-loadbalancer

#resource "azurerm_resource_group" "lb_f5" {
#  name     = "LoadBalancerRG"
#  location              = var.location
#}

resource "azurerm_public_ip" "lb_f5" {
  name                  = "Azure-LB-Public-IP"
  allocation_method     = var.public_ip_address_allocation
  resource_group_name   = var.resource_group_name
  location              = var.location
  tags                  = var.tags
}

resource "azurerm_lb" "lb_f5" {
  name                  = "TestLoadBalancer"
  location              = var.location
  resource_group_name   = var.resource_group_name
  tags                  = var.tags

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_f5.id
  }
}