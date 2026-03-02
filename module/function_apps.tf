# Function App
module "function_app" {
  for_each = local.function_apps
  source   = "Azure/avm-res-web-site/azurerm"
  version  = "0.21.0"

  location                 = var.location
  name                     = "${module.naming.function_app.name}-${each.value.description}"
  parent_id                = module.resource_group.resource_id
  service_plan_resource_id = module.app_service_plan.resource_id

  os_type = var.app_service_plan.os_type
  app_settings = merge(
    each.value.app_settings,
    {
      "WEBSITE_RUN_FROM_PACKAGE"            = "1"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
      "WEBSITE_ENABLE_SYNC_UPDATE_SITE"     = "true"
    }
  ) #ZipDeploy Defaults for CI/CD
  functions_extension_version            = each.value.functions_extension_version
  application_insights_connection_string = each.value.application_insights_connection_string
  application_insights_key               = each.value.application_insights_key
  storage_account_name                   = module.storage_account[each.key].name
  site_config                            = { application_stack = each.value.application_stack }
  virtual_network_subnet_id              = module.virtual_network.subnets["app_service_plan"].resource.id

  #System Assigned Identity
  
}