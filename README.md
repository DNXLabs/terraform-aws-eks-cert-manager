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

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.13, < 4.0 |
| helm | >= 1.0, < 1.4.0 |
| kubernetes | >= 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 1.0, < 1.4.0 |
| kubernetes | >= 1.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_namespace | Whether to create Kubernetes namespace with name defined by `namespace`. | `bool` | `true` | no |
| enabled | Variable indicating whether deployment is enabled. | `bool` | `true` | no |
| helm\_chart\_name | Cert Manager Helm chart name to be installed | `string` | `"cert-manager"` | no |
| helm\_chart\_release\_name | Helm release name | `string` | `"cert-manager"` | no |
| helm\_chart\_repo | Cert Manager repository name. | `string` | `"https://charts.jetstack.io"` | no |
| helm\_chart\_version | Cert Manager Helm chart version. | `string` | `"1.1.0"` | no |
| install\_CRDs | To automatically install and manage the CRDs as part of your Helm release. | `bool` | `true` | no |
| mod\_dependency | Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable. | `any` | `null` | no |
| namespace | Kubernetes namespace to deploy Cert Manager Helm chart. | `string` | `"cert-manager"` | no |
| settings | Additional settings which will be passed to the Helm chart values. | `map(any)` | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/blob/master/LICENSE) for full details.
