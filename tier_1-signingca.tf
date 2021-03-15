resource "tls_private_key" "signingca" {
  algorithm = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_cert_request" "signingca" {
  key_algorithm   = tls_private_key.signingca.algorithm
  private_key_pem = tls_private_key.signingca.private_key_pem

  subject {
    common_name  = "Signing CA"
    organization = local.organisation
    street_address = [local.street_address]
  }
}

resource "tls_locally_signed_cert" "signingca" {
  cert_request_pem   = tls_cert_request.signingca.cert_request_pem
  ca_key_algorithm   = tls_private_key.rootca.algorithm
  ca_private_key_pem = tls_private_key.rootca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.rootca.cert_pem

  is_ca_certificate     = true
  validity_period_hours = "${5 * 365 * 24}" # 5 years

  early_renewal_hours = "${2 * 365 * 24}" # 2 years prior to expiration

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "ocsp_signing",
    "digital_signature",
    "key_encipherment"
  ]
}


resource "local_file" "signingca_crt" {
  sensitive_content = "${tls_locally_signed_cert.signingca.cert_pem}"
  filename          = "${path.root}/certs/signingca/cert.crt"
}
resource "local_file" "signingca_key" {
  sensitive_content = "${tls_private_key.signingca.private_key_pem}"
  filename          = "${path.root}/certs/signingca/cert.key"
}