# terraform-aws-eks-cert-manager

[![Lint Status](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-eks-cert-manager)](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/blob/master/LICENSE)


Terraform module for deploying Kubernetes [cert-manager](https://cert-manager.io/docs/), cert-manager is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self signed.

## Usage

```
module "cert_manager" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-cert-manager.git"

  enabled = true
}
```

<!--- BEGIN_TF_DOCS --->
<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/blob/master/LICENSE) for full details.
