resource "tls_private_key" "client" {
    for_each = var.client_cert_fqdn
    # count = length(var.client_cert_fqdn)
    algorithm = "ECDSA"
    ecdsa_curve = "P521"
}

resource "tls_cert_request" "client" {
  for_each = var.client_cert_fqdn
  # count = length(var.client_cert_fqdn)
  key_algorithm   = tls_private_key.issuingca.algorithm
  private_key_pem = tls_private_key.issuingca.private_key_pem

  subject {
    # common_name  = element(var.client_cert_fqdn,count.index)
    common_name = each.key
    organization = local.organisation
    street_address = [local.street_address]
  }
}

resource "tls_locally_signed_cert" "client" {
  for_each = var.client_cert_fqdn
  cert_request_pem   = tls_cert_request.client[each.key].cert_request_pem
  ca_key_algorithm   = tls_private_key.issuingca.algorithm
  ca_private_key_pem = tls_private_key.issuingca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.rootca.cert_pem

  is_ca_certificate     = false
  validity_period_hours = "${30 * 24}" #  30 days

  early_renewal_hours = "${7 * 24}" # 7 days

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
}




resource "local_file" "client_crt" {
  for_each = var.client_cert_fqdn
  sensitive_content = "${tls_locally_signed_cert.signingca.cert_pem}${tls_locally_signed_cert.issuingca.cert_pem}${tls_locally_signed_cert.client[each.key].cert_pem}"
  filename          = "${path.root}/certs/client/${each.key}/cert.crt"
}
resource "local_file" "client_key" {
  for_each = var.client_cert_fqdn
  sensitive_content = "${tls_private_key.client[each.key].private_key_pem}"
  filename          = "${path.root}/certs/client/${each.key}/cert.key"
}