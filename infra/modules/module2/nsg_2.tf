locals {
  nsg_data = yamldecode(file("${path.module}/../../data/nsg_rules_2.yaml")).nsgs
}

resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name_2
  location = var.location
}

resource "azurerm_network_security_group" "app_nsg_2" {
  for_each            = local.nsg_data
  name                = each.key
  location            = each.value.location
  resource_group_name = azurerm_resource_group.app_rg.name
}

resource "azurerm_network_security_rule" "app_rule" {
  for_each = merge([
    for nsg_name, nsg in local.nsg_data : {
      for rule in nsg.rules :
      "${nsg_name}-${rule.name}" => {
        nsg_name = nsg_name
        location = nsg.location
        rule     = rule
      }
    }
  ]...)

  name                         = each.value.rule.name
  priority                     = each.value.rule.priority
  direction                    = each.value.rule.direction
  access                       = each.value.rule.access
  protocol                     = each.value.rule.protocol
  source_port_range            = each.value.rule.source_port_range
  destination_port_range       = each.value.rule.destination_port_range
  source_address_prefixes      = try(each.value.rule.source_address_prefixes, [])
  destination_address_prefixes = try(each.value.rule.destination_address_prefixes, [])

  resource_group_name         = azurerm_resource_group.app_rg.name
  network_security_group_name = each.value.nsg_name
}
