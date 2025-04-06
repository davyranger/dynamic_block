resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name # Name of the resource group
  location = var.location            # Azure region where the resource group is located
}

### test azure resource to create a severity of CRITICAL (**DO NOT DEPLOY**)
# resource "azurerm_storage_account" "example" {
#   name                     = "testresourceforseveritychecks" #needs to be globally unique
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   depends_on = [ azurerm_resource_group.rg ]
# }
