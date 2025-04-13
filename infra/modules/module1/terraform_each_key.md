# Azure Network Security Group Terraform Configuration

This Terraform module provisions an **Azure Network Security Group (NSG)** and dynamically loads **ingress rules** from an external YAML file.

---

## ⚙️ How It Works

1. **YAML Decoding**:  
   The `locals` block uses `yamldecode()` to load and parse the `nsg_rules.yaml` file. This file contains a list of ingress rules structured in YAML.

2. **Resource Group Creation**:  
   A resource group is created using the `azurerm_resource_group` resource, using variables for its name and location.

3. **NSG Creation**:  
   An `azurerm_network_security_group` resource is defined, and its security rules are populated dynamically.

4. **Dynamic Block for Rules**:  
   The `dynamic` block iterates through the decoded YAML rules:
   - `for_each = flatten(local.ingress_config.ingress_rules)`  
   - Each rule in the YAML becomes a `security_rule` block in the NSG.

5. **Error Handling**:  
   The `try()` function is used for optional fields like `source_address_prefixes` and `destination_address_prefixes` to prevent errors if these fields are missing.

6. **Reusable & Scalable**:  
   This setup allows rule definitions to be managed outside Terraform, making it easy to update rules without changing the Terraform code itself.

---

## 📜 Terraform Configuration (`main.tf`)

```hcl
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
