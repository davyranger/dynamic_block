module "nsg_1" {
  source              = "../modules/module1"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# placeholder for additional resources
# module "additional_resources" {
#   source                = "../modules/module2"
#   resource_group_name_2 = var.resource_group_name_2
#   location              = var.location
# }

# example import block for nsg_1 module
# import {
#       to = module.nsg_1.azurerm_network_security_group.app_nsg["test"]
#       id = "/subscriptions/************************/resourceGroups/template_resource_group/providers/Microsoft.Network/networkSecurityGroups/test"
# }