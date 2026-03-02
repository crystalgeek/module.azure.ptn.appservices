module "app_service_plan" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "2.0.2"

  tags = local.tags

  name      = module.naming.app_service_plan.name
  location  = var.location
  parent_id = module.resource_group.resource_id
  os_type   = var.app_service_plan.os_type

  sku_name               = var.app_service_plan.sku_name
  zone_balancing_enabled = var.app_service_plan.zone_balancing_enabled
}