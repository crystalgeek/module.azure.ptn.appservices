module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.3"

  suffix = [var.suffix, var.environment]
}