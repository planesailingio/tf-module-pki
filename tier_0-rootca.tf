resource "tls_private_key" "rootca" {
  algorithm = "ECDSA"
  ecdsa_curve = "P521"
}


resource "tls_self_signed_cert" "rootca" {
  key_algorithm   = tls_private_key.rootca.algorithm
  private_key_pem = tls_private_key.rootca.private_key_pem

  # Certificate expires after 12 hours.
  validity_period_hours = "${48 * 365 * 24}" # 48 years

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = "${10 * 365 * 24}" # 10 years prior to expiry

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "ocsp_signing",
    "digital_signature",
    "key_encipherment"
  ]

  is_ca_certificate = true
  subject {
    common_name  = "Root CA"
    organization = local.organisation
    street_address = [local.street_address]
  }
}



resource "local_file" "rootca_crt" {
  sensitive_content = "${tls_self_signed_cert.rootca.cert_pem}"
  filename          = "${path.root}/certs/rootca/cert.crt"
}
resource "local_file" "rootca_key" {
  sensitive_content = "${tls_private_key.rootca.private_key_pem}"
  filename          = "${path.root}/certs/rootca/cert.key"
}