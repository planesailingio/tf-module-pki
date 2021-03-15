variable "client_cert_fqdn" {
  default = {
    "planesailing.io" = {}
    "rhysevans.co.uk" = {}
    "yourdomain.com" = {}
  }
}

variable "export_certmgr" {
  type        = bool
  description = "Simple switch to generate the Kubneretes manifest for Cert manager. The Issuing CA key pair is used."
  default     = true
}

locals {
    organisation = "PlaneSailing.io"
    street_address = "London"
}