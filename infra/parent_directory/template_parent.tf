# =============================
# Azure Resource Group
# =============================
# Create a resource group in Azure

module "resource_group" {
  source              = "../modules/module1"
  resource_group_name = var.resource_group_name
  location            = var.location
}

