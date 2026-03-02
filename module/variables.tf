# Naming Variables
variable "suffix" {
  type        = string
  description = "(Required) Naming Suffix for the application stack"
}
variable "environment" {
  type        = string
  description = "(Required) Environment to deploy for the application stack"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "The environment must be one of: dev, test, or prod."
  }
}

# Location
variable "location" {
  type        = string
  description = "(Required) Location for the application stack"
}

# Network Settings
variable "vnet_address_space" {
  type        = string
  description = "(Required) Vnet Address Space"

  validation {
    condition     = endswith(var.vnet_address_space, "/25")
    error_message = "This pattern requires a /25 to properly create the App Service and Private Endpoint subnets."
  }
}

# App Service Plan
variable "app_service_plan" {
  type = object({
    os_type                = optional(string)
    sku_name               = optional(string)
    zone_balancing_enabled = optional(bool)
  })
  default = {
    os_type                = "Linux"
    sku_name               = "B1"
    zone_balancing_enabled = true
  }
  description = "(Optional) The OS and SKU for the app service plan."
}

#Function Apps
variable "function_apps" {
  type = map(object({
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
  default     = {}
  description = "Optional: Map of function apps with associated settings."
}

#ToDo:
#Logic Apps
#Web Apps
#Key Vault Secrets
#Validation