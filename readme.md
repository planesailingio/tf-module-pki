# Terraform PKI Module

This module creates a basic three tier certificate chain using Terraform.    
BRUCY BONUS: I do a lot of work in Kubernetes so the module also creates a K8s secret for Cert-Manager.

To secure the credentials refer to tools such as [Stackoverflow/Blackbox](https://github.com/StackExchange/blackbox) that leverage GPG cryptography.

The module will generate;
- Root CA
- Signing CA
- Issuing CA
- Several client certificates that you can use to terminate TLS
Inspect the `vars.tf` file to configure names and certificate common names.

```
git clone git@github.com:planesailingio/tf-module-pki.git && cd tf-module-pki
terraform init && terraform apply -auto-approve
```

After running a certs folder will be created with subfolders for each certificate tier. I do a lot of work with 
```
├── ca-cluster-issuer.yaml
├── client
│   ├── rhysevans.co.abc
│   │   ├── cert.crt
│   │   └── cert.key
│   ├── rhysevans.co.uk
│   │   ├── cert.crt
│   │   └── cert.key
│   └── rhysevans.co.xyz
│       ├── cert.crt
│       └── cert.key
├── issuingca
│   ├── cert.crt
│   └── cert.key
├── rootca
│   ├── cert.crt
│   └── cert.key
└── signingca
    ├── cert.crt
    └── cert.key
```
