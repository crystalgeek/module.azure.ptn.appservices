#Key Vault: Administrator - Current User
resource "azurerm_role_assignment" "key_vault_administrator" {
  scope                = module.key_vault.resource_id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
}
#Key Vault: Certificate User - Function App
resource "azurerm_role_assignment" "function_key_vault_access" {
  for_each             = module.function_app
  scope                = module.key_vault.resource_id
  principal_id         = module.function_app[each.key].identity_principal_id
  role_definition_name = "Key Vault Certificate User"
}
