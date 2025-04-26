# Load all YAML file names from the '../../data' directory
locals {
  yaml_files = fileset("${path.module}/../../data", "*.yaml")

  # Decode each YAML file and merge all resulting maps into a single map
  # `try(..., {})` ensures the config won't fail if a file can't be decoded
  nsg_data = merge([
    for file in local.yaml_files : 
    try(yamldecode(file("${path.module}/../../data/${file}")), {})
  ]...)
}

# Create a resource group for the NSGs
resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a network security group for each entry in the merged YAML data
resource "azurerm_network_security_group" "app_nsg" {
  for_each            = local.nsg_data
  name                = each.key                              # NSG name (e.g., app-nsg-1)
  location            = each.value.location                  # Location from YAML
  resource_group_name = azurerm_resource_group.app_rg.name   # RG from above

  # Create dynamic security rules for each NSG
  dynamic "security_rule" {
    for_each = each.value.rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      protocol                     = security_rule.value.protocol

      # Use try() to handle optional fields gracefully
      source_address_prefixes      = try(security_rule.value.source_address_prefixes, [])
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, [])
    }
  }
}
