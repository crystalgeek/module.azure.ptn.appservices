module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.2"

  name     = module.naming.resource_group.name
  location = var.location
}