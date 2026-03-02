resource "tls_private_key" "client_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client_csr" {
  for_each        = module.function_app
  private_key_pem = tls_private_key.client_key.private_key_pem

  subject {
    common_name  = module.function_app[each.key].resource_uri
    organization = "Platform Team"
  }
}

resource "tls_locally_signed_cert" "client_cert" {
  for_each           = module.function_app
  cert_request_pem   = tls_cert_request.client_csr[each.key].cert_request_pem
  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "client_auth",
    "digital_signature",
  ]
}