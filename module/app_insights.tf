module "app_insights" {
  for_each = local.app_insights
  source   = "Azure/avm-res-insights-component/azurerm"
  version  = "0.3.0"

  name                = module.naming.application_insights.name
  location            = var.location
  resource_group_name = module.resource_group.name
  workspace_id        = module.log_analytics_workspace.resource_id
}