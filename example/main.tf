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

  # ToDo: Tags
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