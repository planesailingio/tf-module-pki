# resource "local_file" "rootca_key" {
#   count             = var.export_keys ? 1 : 0
#   sensitive_content = tls_private_key.rootca.private_key_pem
#   filename          = "${path.root}/certs/rootca.key"
# }
# resource "local_file" "subca_key" {
#   count             = var.export_keys ? 1 : 0
#   sensitive_content = tls_private_key.subca.private_key_pem
#   filename          = "${path.root}/certs/subca.key"
# }


# resource "local_file" "rootca_cert" {
#   count             = var.export_keys ? 1 : 0
#   sensitive_content = tls_self_signed_cert.rootca.cert_pem
#   filename          = "${path.root}/certs/rootca.crt"
# }
# resource "local_file" "subca_cert" {
#   count             = var.export_keys ? 1 : 0
#   sensitive_content = tls_locally_signed_cert.subca.cert_pem
#   filename          = "${path.root}/certs/subca.crt"
# }






# resource "tls_private_key" "client" {
#   algorithm = "ECDSA"
#   ecdsa_curve = "P384"
# }

# resource "tls_cert_request" "client" {
#   key_algorithm   = "ECDSA"
#   private_key_pem = tls_private_key.client.private_key_pem

#   subject {
#     common_name  = "Somesuperawesome certificate"
#     organization = "Flexciton Ltd."
#     street_address = ["London"]
#   }
# }



# resource "tls_locally_signed_cert" "client" {
#   cert_request_pem   = tls_cert_request.client.cert_request_pem
#   ca_key_algorithm   = "ECDSA"
#   ca_private_key_pem = tls_private_key.subca.private_key_pem
#   ca_cert_pem        = tls_locally_signed_cert.subca.cert_pem

#   is_ca_certificate     = false
#   validity_period_hours = "${10 * 24}"

#   early_renewal_hours = "${2 * 24}"

#   allowed_uses = [
#     "digital_signature",
#     "key_encipherment",
#     "server_auth",
#     # "client_auth"
#   ]
# }

# resource "local_file" "client_cert" {
#   # count             = var.export_keys ? 1 : 0
#   sensitive_content = "${tls_locally_signed_cert.subca.cert_pem}\n${tls_locally_signed_cert.client.cert_pem}"
#   filename          = "${path.root}/certs/client.crt"
# }


# resource "local_file" "client_key" {
#   # count             = var.export_keys ? 1 : 0
#   sensitive_content = tls_private_key.client.private_key_pem
#   filename          = "${path.root}/certs/client.key"
# }

# data "template_file" "cert-manager-yaml" {
#   template = <<EOF
# apiVersion: v1
# kind: Secret
# type: kubernetes.io/tls
# metadata:
#   name: ca-key-pair
#   namespace: cert-manager
# data:
#   tls.crt: $${cert}
#   tls.key: $${key}
# EOF
#   vars = {
#     cert = base64encode(tls_locally_signed_cert.issuingca.cert_pem)
#     key = base64encode(tls_private_key.issuingca.private_key_pem)
#   }
# }

# resource "local_file" "cert-manager-yaml" {
#   sensitive_content = data.template_file.cert-manager-yaml.rendered
#   filename          = "${path.root}/certs/ca-key-issuer.yaml"
# }
