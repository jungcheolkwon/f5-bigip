#https://github.com/F5Networks/f5-declarative-onboarding
#F5 BIG-IP Creating
resource "azurerm_virtual_machine" "F5" {
  count                 = var.nb_instances
  name                  = "bigip1-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  tags                  = var.tags
  network_interface_ids = ["${element(azurerm_network_interface.F5.*.id, count.index)}"]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_os_disk {
    name              = "bigip1-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }

  plan {
    name      = var.vm_os_sku
    publisher = var.vm_os_publisher
    product   = var.vm_os_offer
  }

  os_profile {
    computer_name  = "${var.vm_hostname}-${count.index}"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("${var.ssh_key}")
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.F5.primary_blob_endpoint
  }

}

resource "azurerm_public_ip" "F5" {
  count                 = var.nb_public_ip
  name                  = "bigip1-${count.index}"
  allocation_method     = var.public_ip_address_allocation
#  domain_name_label     = "${element(var.public_ip_dns, count.index)}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  tags                  = var.tags
}

resource "random_id" "F5" {
  keepers = {
    vm_hostname = "bigip1"
    resource_group_name = var.resource_group_name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "F5" {
  name                     = "diag${random_id.F5.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

resource "azurerm_network_interface" "F5" {
  count                     = var.nb_interfaces
  name                      = "bigip1-NIC-${count.index}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  tags                      = var.tags
  network_security_group_id = var.network_security_group_id

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.1.10"
    public_ip_address_id          = length(azurerm_public_ip.F5.*.id) > 0 ? element(concat(azurerm_public_ip.F5.*.id, list("")), count.index) : ""
  }
}

# Running to change passwrod for admin
#provisioner "local-exec" {
#  command = <<-EOF
#    #!/bin/bash
#    name = file("${var.user}")
#    password = file("${var.passwd}")
#    token=$(curl -sk -H "Content-Type: application/json" -X POST -d '{"username":"'$name'","password":"'$password'","loginProviderName":"tmos"}' https://$1:8443/mgmt/shared/authn/login | jq -r .token.token)
#    curl -sk -H "Content-Type: application/json" -H "X-F5-Auth-Token: $token" -X PATCH -d '{"oldPassword": "'$3'", "newPassword": "'$4'" }' https://$1:8443/mgmt/shared/authn/$user | jq -r .
#  EOF
#}

#provider "bigip" {
#   #address = "${azurerm_public_ip_address.*.ip_address}:8443"
#   address = "13.76.132.229:8443"
#   username = "admin"
#   password = "admin@Demo"
#   username = file("${var.user}")
#   password = file("${var.passwd}")
#}

#resource "bigip_cm_device" "new_device" {
#  count                 = var.nb_instances
#  name = "bigip1.f5.com"
#  configsync_ip = "172.16.1.6"
#  configsync_ip = azurerm_network_interface.F5 
#  mirror_ip = "172.16.1.7"
#}

#resource "bigip_cm_devicegroup" "devicegroup" {
#  name              = "syncgroup"
#  auto_sync         = "enabled"
#  full_load_on_sync = "true"
#  type              = "sync-failover"
#  device { name = "bigip1.f5.com" }
#  device { name = "bigip2.f5.com" }
#}
