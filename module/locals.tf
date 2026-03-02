locals {
  # Resource Maps
  # Function Apps
  function_apps = {
    for key, value in var.function_apps : key => {
      description                            = value.description
      type                                   = "function_app"
      app_settings                           = try(value.app_settings, null)
      functions_extension_version            = try(value.function_extension_version, "~4")
      application_stack                      = try(value.application_stack, null)
      application_insights_key               = module.app_insights[key].instrumentation_key
      application_insights_connection_string = module.app_insights[key].connection_string
      shared_access_key_enabled              = true #Required for Function Apps
    }
  }
  # Logic Apps
  logic_apps = {} # Placeholder 
  # Web Apps
  web_apps = {} # Placeholder
  # Storage Accounts
  storage_accounts = merge(local.function_apps, local.logic_apps)
  # App Insights
  app_insights = merge(var.function_apps, local.logic_apps, local.web_apps)

  # Networking 
  # Subnets
  subnet_ranges = cidrsubnets(var.vnet_address_space, 1, 1)
  subnets = {
    app_service_plan = {
      name                              = "${module.naming.subnet.name}-asp"
      address_prefixes                  = [local.subnet_ranges[0]]
      private_endpoint_network_policies = "Enabled"
      delegations = [{
        name = "Microsoft.Web.serverFarms"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
        }
      }]
      network_security_group = { id = module.network_security_group.resource_id }
    }
    private_endpoints = {
      name                              = "${module.naming.subnet.name}-pe"
      address_prefixes                  = [local.subnet_ranges[1]]
      private_endpoint_network_policies = "Enabled"
      network_security_group            = { id = module.network_security_group.resource_id }
    }
  }
  # Private DNS Zones
  private_dns_zones = ["privatelink.vaultcore.azure.net", "privatelink.azurewebsites.net", "privatelink.blob.core.windows.net"]
  virtual_network_links = {
    default = {
      name               = module.virtual_network.name
      virtual_network_id = module.virtual_network.resource_id
    }
  }
  # Private Endpoints
  function_app_private_endpoints = {
    for key, value in var.function_apps : key => {
      name                           = "${module.naming.private_endpoint.name}-${value.description}"
      private_connection_resource_id = module.function_app[key].resource_id
      subresource_names              = ["sites"]
      network_interface_name         = "${module.naming.network_interface.name}-${value.description}"
      private_dns_zone_ids           = ["${module.resource_group.resource_id}/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
      private_dns_zone_group_name    = "privatelink.azurewebsites.net"
    }
  }
  storage_account_private_endpoint_blobs = {
    for key, value in local.storage_accounts : "stb_${key}" => {
      name                           = "${module.naming.private_endpoint.name}-blb${value.description}"
      private_connection_resource_id = module.storage_account[key].resource_id
      subresource_names              = ["blob"]
      network_interface_name         = "${module.naming.network_interface.name}-blb${value.description}"
      private_dns_zone_ids           = ["${module.resource_group.resource_id}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
      private_dns_zone_group_name    = "privatelink.blob.core.windows.net"
    }
  }
  private_endpoints = merge({
    key_vault_private_endpoint = {
      name                           = "${module.naming.private_endpoint.name}-kv"
      private_connection_resource_id = module.key_vault.resource_id
      subresource_names              = ["vault"]
      network_interface_name         = "${module.naming.network_interface.name}-kv"
      private_dns_zone_ids           = ["${module.resource_group.resource_id}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
      private_dns_zone_group_name    = "privatelink.vaultcore.azure.net"
  } }, local.function_app_private_endpoints, local.storage_account_private_endpoint_blobs)

  # Client Certificates
  client_certs = {
    for key, value in tls_locally_signed_cert.client_cert : key => tls_locally_signed_cert.client_cert[key].cert_pem
  }

  # Resource Tagging
  tags = merge(
    #var.tags,
    {
      "ManagedBy"   = "Platform-Team"
      "Pattern"     = "ptn_appservices"
      "LastUpdated" = timestamp()
    }
  )
}