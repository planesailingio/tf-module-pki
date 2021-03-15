data "template_file" "cert-manager-yaml" {
  template = <<EOF
apiVersion: v1
kind: Secret
type: kubernetes.io/tls
metadata:
  name: ca-key-pair
  namespace: cert-manager
data:
  tls.crt: $${cert}
  tls.key: $${key}
EOF
  vars = {
    cert = base64encode(tls_locally_signed_cert.issuingca.cert_pem)
    key = base64encode(tls_private_key.issuingca.private_key_pem)
  }
}

resource "local_file" "cert-manager-yaml" {
  count = var.export_certmgr ? 1 : 0
  sensitive_content = data.template_file.cert-manager-yaml.rendered
  filename          = "${path.root}/certs/ca-cluster-issuer.yaml"
}