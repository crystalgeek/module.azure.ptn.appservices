module "virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  tags = local.tags

  address_space = [var.vnet_address_space]
  location      = var.location
  name          = module.naming.virtual_network.name
  parent_id     = module.resource_group.resource_id
  subnets       = local.subnets
}