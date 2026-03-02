module "private_endpoints" {
  for_each = local.private_endpoints
  source   = "Azure/avm-res-network-privateendpoint/azurerm"
  version  = "0.2.0"

  name                           = each.value.name
  location                       = var.location
  resource_group_name            = module.resource_group.name
  subnet_resource_id             = module.virtual_network.subnets["private_endpoints"].resource.id
  private_connection_resource_id = each.value.private_connection_resource_id
  network_interface_name         = each.value.network_interface_name
  private_dns_zone_resource_ids  = each.value.private_dns_zone_ids
  private_dns_zone_group_name    = each.value.private_dns_zone_group_name
  subresource_names              = each.value.subresource_names
}