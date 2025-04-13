# =============================
# Azure Resource Group
# =============================
# Create a resource group in Azure

module "resource_group" {
  source              = "../modules/module1"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "resource_group_2" {
  source              = "../modules/module2"
  resource_group_name = var.resource_group_name
  location            = var.location
}

