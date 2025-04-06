
# Understanding `each.key` in Terraform `for_each` with YAML Input

## 📘 Overview

This document explains how Terraform understands `each.key` when using a `for_each` loop to create multiple Azure Resource Groups based on input from a YAML file.

---

## 🧾 YAML Structure

```yaml
resource_groups:
  "rg-01":
    location: "australiaeast"
    tags:
      description: "this is a test resource group"
  "rg-02":
    location: "australiaeast"
    tags:
      description: "This is a second resource group"
  "rg-03":
    location: "australiaeast"
    tags:
      description: "This is a third resource group"
```

---

## 📦 Terraform Code

```hcl
locals {
  yaml_rg = yamldecode(file("${path.module}/../../data/clients.yml"))
}

resource "azurerm_resource_group" "this" {
  for_each = local.yaml_rg.resource_groups

  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}
```

---

## 🧠 How It Works

### What Terraform sees after decoding:
The YAML input is decoded into a map like this:

```hcl
{
  "rg-01" = {
    location = "australiaeast"
    tags = {
      description = "this is a test resource group"
    }
  },
  "rg-02" = {
    location = "australiaeast"
    tags = {
      description = "This is a second resource group"
    }
  },
  "rg-03" = {
    location = "australiaeast"
    tags = {
      description = "This is a third resource group"
    }
  }
}
```

### Inside the `for_each` loop:
- `each.key` will be `"rg-01"`, `"rg-02"`, etc.
- `each.value` refers to the object containing `location` and `tags`.

### Resource Parameters:
- `name = each.key` assigns the map key as the name of the Azure resource group.
- `location = each.value.location` pulls the location from the YAML map.
- `tags = each.value.tags` adds any tags from the YAML.

---

## 🧪 Pro Tip: Use `terraform console`

To view the decoded structure:

```bash
terraform console
> local.yaml_rg.resource_groups
```

You should see a map like the one above.

---

## ✅ Summary

Using `each.key` with `for_each` on a decoded YAML map lets you dynamically create resources using keys as identifiers. This approach is clean, DRY, and perfect for environments with multiple groups or configurations.
