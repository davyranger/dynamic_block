# =============================
# Azure Resource Group
# =============================
# Create a resource group in Azure

module "nsg_1" {
  source              = "../modules/module1"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# module "nsg_2" {
#   source                = "../modules/module2"
#   resource_group_name_2 = var.resource_group_name_2
#   location              = var.location
# }

# import {
#       to = module.nsg_1.azurerm_network_security_group.app_nsg["test"]
#       id = "/subscriptions/4897f781-f85c-4e73-9c2e-1ddee2c3f763/resourceGroups/template_resource_group/providers/Microsoft.Network/networkSecurityGroups/test"
# }