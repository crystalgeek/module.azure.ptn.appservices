module "private_dns_zone" {
  for_each = toset(local.private_dns_zones)
  source   = "Azure/avm-res-network-privatednszone/azurerm"
  version  = "0.5.0"

  domain_name = each.value
  parent_id   = module.resource_group.resource_id

  virtual_network_links = local.virtual_network_links
}