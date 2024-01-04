# Linux Kernel Development Environment
Init environment for Linux Kernel development. **(Based on LFD103 guidelines)**

## GCP VM
-> Create new VM: [Terraform template](vm_gcp_template.tf)

## Configuring development system
-> Review `setup_environment.sh`
-> Remove `X.509` default debian certs on `make menuconfig` (Cryptographic API -> Certificates for signature checking)
