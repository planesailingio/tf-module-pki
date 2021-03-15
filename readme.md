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


## Getting Started
### Step 1
```
git clone git@github.com:planesailingio/tf-module-pki.git && cd tf-module-pki
```
### Step 2
Configure `client_cert_fqdn` in `vars.tf` with your FQDN's you want client certificates to be created.
### Step 3
Run `terraform init && terraform apply -auto-approve`    
After terraform finishes, a certs folder will be created called `certs` with subfolders for each certificate tier.   
As an example:
```
certs
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

### Step 4
Distribute and import the `certs/rootca/cert.crt` into your services, systems or browsers.    
NOTE: This module doesn't provide supporting 'production' PKI infrastructure e.g. Authority Information Access URI's (AIA) nor Certificate Revocation Lists (CRL's) as such the chain must be provided in the client certificates - This is done for you with client certificates built with this module.

### You're good to go!
Use your new certificates and they will be trusted by your clients such as a web browser.