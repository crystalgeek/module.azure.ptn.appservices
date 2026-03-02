# module.azure.ptn.appservices
Secure Azure Module for deploying multiple app services

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Modules

The following Modules are called:

### <a name="module_app_insights"></a> [app\_insights](#module\_app\_insights)

Source: Azure/avm-res-insights-component/azurerm

Version: 0.3.0

### <a name="module_app_service_plan"></a> [app\_service\_plan](#module\_app\_service\_plan)

Source: Azure/avm-res-web-serverfarm/azurerm

Version: 2.0.2

### <a name="module_function_app"></a> [function\_app](#module\_function\_app)

Source: Azure/avm-res-web-site/azurerm

Version: 0.21.0

### <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault)

Source: Azure/avm-res-keyvault-vault/azurerm

Version: 0.10.2

### <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace)

Source: Azure/avm-res-operationalinsights-workspace/azurerm

Version: 0.5.1

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: 0.4.3

### <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group)

Source: Azure/avm-res-network-networksecuritygroup/azurerm

Version: 0.5.1

### <a name="module_private_dns_zone"></a> [private\_dns\_zone](#module\_private\_dns\_zone)

Source: Azure/avm-res-network-privatednszone/azurerm

Version: 0.5.0

### <a name="module_private_endpoints"></a> [private\_endpoints](#module\_private\_endpoints)

Source: Azure/avm-res-network-privateendpoint/azurerm

Version: 0.2.0

### <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group)

Source: Azure/avm-res-resources-resourcegroup/azurerm

Version: 0.2.2

### <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account)

Source: Azure/avm-res-storage-storageaccount/azurerm

Version: 0.6.7

### <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network)

Source: Azure/avm-res-network-virtualnetwork/azurerm

Version: 0.17.1

## Resources

The following resources are used by this module:

- [azurerm_role_assignment.function_key_vault_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_role_assignment.key_vault_administrator](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

## Example
```hcl
#Random Suffix
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "ptn_appservices" {
  source = "../module"

  # Naming Standards
  suffix      = random_string.suffix.result
  environment = "snd"

  # Tags
  # tags = { key = "value"}

  # Module Required Settings
  location = "Canada Central" # Required: Location.
  # Network Settings
  vnet_address_space = "10.0.0.0/25" # Required: Must be a /25 range.

  # Module Optional Settings
  # App Service Plan
  app_service_plan = {
    os_type                = "Linux" # Optional: OS Type for App Service Plan and Apps. Supports "Windows" or "Linux". Defaults to Linux.
    sku_name               = "B1"    # Optional: App Service Plan SKU. Supports S1,S2 etc. Defaults to B1.
    zone_balancing_enabled = false   # Optional: Enable Zone Redundancy. Defaults to true.
  }

  # Function Apps
  function_apps = {
    function_app_1 = {
      description                 = "fn1" # Required: Description for the name of the function app
      app_settings                = {}    # Optional: defaults to {}
      functions_extension_version = "~4"  # Optional: defaults to "~4"
      # Application Stack Settings
      application_stack = {
        dotnet_version              = null # Optional: defaults to "null"
        use_dotnet_isolated_runtime = null # Optional: defaults to "false"
        java_version                = null # Optional: defaults to "null"
        node_version                = null # Optional: defaults to "null"
        powershell_core_version     = null # Optional: defaults to "null"
        python_version              = null # Optional: defaults to "null"
        use_custom_runtime          = null # Optional: defaults to "null"
      }                                    # Optional Application Stack Setting
    }
  }

  # ToDo:
  # Logic Apps
  # Web Apps
  # Additional Key Vault Secrets

}
```

## Required Inputs

The following input variables are required:

### <a name="input_environment"></a> [environment](#input\_environment)

Description: (Required) Environment to deploy for the application stack

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: (Required) Location for the application stack

Type: `string`

### <a name="input_suffix"></a> [suffix](#input\_suffix)

Description: (Required) Naming Suffix for the application stack

Type: `string`

### <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space)

Description: (Required) Vnet Address Space

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan)

Description: (Optional) The OS and SKU for the app service plan.

Type:

```hcl
object({
    os_type                = optional(string)
    sku_name               = optional(string)
    zone_balancing_enabled = optional(bool)
  })
```

Default:

```json
{
  "os_type": "Linux",
  "sku_name": "B1",
  "zone_balancing_enabled": true
}
```

### <a name="input_function_apps"></a> [function\_apps](#input\_function\_apps)

Description: Optional: Map of function apps with associated settings.

Type:

```hcl
map(object({
    description                 = string
    app_settings                = optional(map(any))
    functions_extension_version = optional(string)
    application_stack = optional(object({
      dotnet_version              = optional(string)
      use_dotnet_isolated_runtime = optional(bool)
      java_version                = optional(string)
      node_version                = optional(string)
      powershell_core_version     = optional(string)
      python_version              = optional(string)
      use_custom_runtime          = optional(bool)
    }))
  }))
```

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id)

Description: The ID of the Resource Group.

### <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name)

Description: The Name of the Resource Group.
