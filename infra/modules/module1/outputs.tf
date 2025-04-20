# This output block defines a map output of all NSG resource IDs
output "azurerm_network_security_group_ids" {
  value = {
    # Loop through each NSG in the azurerm_network_security_group.app_nsg map
    for key, nsg in azurerm_network_security_group.app_nsg :
    # Use the key (e.g., "app-nsg-frontend") as the map key and the NSG's ID as the value
    key => nsg.id
  }
}