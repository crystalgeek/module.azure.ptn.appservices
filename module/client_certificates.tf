resource "azurerm_key_vault_certificate" "client_cert" {

  for_each = module.function_app

  name         = module.function_app.name
  key_vault_id = module.key_vault.resource_id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_type   = "RSA"
      key_size   = "4096"
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  depends_on = [ azurerm_role_assignment.key_vault_administrator ]
}