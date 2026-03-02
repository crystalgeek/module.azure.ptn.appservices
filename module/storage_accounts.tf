module "storage_account" {
  for_each = local.storage_accounts
  source   = "Azure/avm-res-storage-storageaccount/azurerm"
  version  = "0.6.7"

  name                          = "${module.naming.storage_account.name}${each.value.description}"
  location                      = var.location
  resource_group_name           = module.resource_group.name
  public_network_access_enabled = false                                            #Because no private build agents in POC                                            
  shared_access_key_enabled     = try(each.value.shared_access_key_enabled, false) #Support for Function Apps
}