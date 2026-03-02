module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.5.1"

  name                = module.naming.application_insights.name
  location            = var.location
  resource_group_name = module.resource_group.name
}