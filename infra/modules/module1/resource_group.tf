locals {
  ingress_config = yamldecode(file("${path.module}/../../data/nsg_rules.yaml"))
}

resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "app-nsg-${var.resource_group_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.app_rg.name

  dynamic "security_rule" {
    for_each = flatten(local.ingress_config.ingress_rules)
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      protocol                     = security_rule.value.protocol
      source_address_prefixes      = try(security_rule.value.source_address_prefixes, [])
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, [])
    }
  }
}
