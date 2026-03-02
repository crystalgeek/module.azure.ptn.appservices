module "network_security_group" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.5.1"

  name                = module.naming.network_security_group.name
  location            = var.location
  resource_group_name = module.resource_group.name
}