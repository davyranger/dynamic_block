locals {
  yaml_rg = yamldecode(file("${path.module}/../../data/clients.yml"))
}

resource "azurerm_resource_group" "this" {
  for_each = local.yaml_rg.resource_groups

  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}