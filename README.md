# terraform-aws-eks-cert-manager

[![Lint Status](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-eks-cert-manager)](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/blob/master/LICENSE)


Terraform module for deploying Kubernetes [cert-manager](https://cert-manager.io/docs/), cert-manager is a native Kubernetes certificate management controller. It can help with issuing certificates from a variety of sources, such as Let’s Encrypt, HashiCorp Vault, Venafi, a simple signing key pair, or self signed.

## Usage

```bash
module "cert_manager" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-cert-manager.git"

  enabled = true

  cluster_name                     = module.eks_cluster.cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks_cluster.oidc_provider_arn

  dns01 = [
    {
      name           = "letsencrypt-staging"
      namespace      = "default"
      kind           = "ClusterIssuer"
      dns_zone       = "example.com"
      region         = "us-east-1" # data.aws_region.current.name
      secret_key_ref = "letsencrypt-staging"
      acme_server    = "https://acme-staging-v02.api.letsencrypt.org/directory"
      acme_email     = "your@email.com"
    },
    {
      name           = "letsencrypt-prod"
      namespace      = "default"
      kind           = "ClusterIssuer"
      dns_zone       = "example.com"
      region         = "us-east-1" # data.aws_region.current.name
      secret_key_ref = "letsencrypt-prod"
      acme_server    = "https://acme-v02.api.letsencrypt.org/directory"
      acme_email     = "your@email.com"
    }
  ]

  # In case you want to use HTTP01 challenge method uncomend this section
  # and comment dns01 variable
  # http01 = [
  #   {
  #     name           = "letsencrypt-staging"
  #     kind           = "ClusterIssuer"
  #     ingress_class  = "nginx"
  #     secret_key_ref = "letsencrypt-staging"
  #     acme_server    = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #     acme_email     = "your@email.com"
  #   },
  #   {
  #     name           = "letsencrypt-prod"
  #     kind           = "ClusterIssuer"
  #     ingress_class  = "nginx"
  #     secret_key_ref = "letsencrypt-prod"
  #     acme_server    = "https://acme-v02.api.letsencrypt.org/directory"
  #     acme_email     = "your@email.com"
  #   }
  # ]
}
```

#### ingress.yaml

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress
  namespace: default
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod # This should match the ClusterIssuer created
    # cert-manager.io/issuer: letsencrypt-prod # In case you choose Issuer instead of ClusterIssuer
  labels:
    app: app
spec:
  rules:
  - host: app.example.com
    http:
      paths:
        - path: /*
          backend:
            serviceName: service
            servicePort: 80
  tls:
    - hosts:
        # - "*.example.com" # Example of wildcard
        - app.example.com
      secretName: app-example-com-prod-tls
```

#### Detached Wildcard Certificate
```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: example-com
  namespace: default
spec:
  secretName: example-com-tls
  issuerRef:
    name: letsencrypt-prod
  dnsNames:
  - '*.example.com'
```

<!--- BEGIN_TF_DOCS --->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.13, < 4.0 |
| helm | >= 1.0, < 1.4.0 |
| kubectl | 1.9.4 |
| kubernetes | >= 1.10.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.13, < 4.0 |
| helm | >= 1.0, < 1.4.0 |
| kubectl | 1.9.4 |
| kubernetes | >= 1.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_identity\_oidc\_issuer | The OIDC Identity issuer for the cluster. | `string` | n/a | yes |
| cluster\_identity\_oidc\_issuer\_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account. | `string` | n/a | yes |
| cluster\_name | The name of the cluster | `string` | n/a | yes |
| create\_namespace | Whether to create Kubernetes namespace with name defined by `namespace`. | `bool` | `true` | no |
| dns01 | n/a | <pre>list(object({<br>    name           = string<br>    namespace      = string<br>    kind           = string<br>    dns_zone       = string<br>    region         = string<br>    secret_key_ref = string<br>    acme_server    = string<br>    acme_email     = string<br>  }))</pre> | `[]` | no |
| enabled | Variable indicating whether deployment is enabled. | `bool` | `true` | no |
| helm\_chart\_name | Cert Manager Helm chart name to be installed | `string` | `"cert-manager"` | no |
| helm\_chart\_release\_name | Helm release name | `string` | `"cert-manager"` | no |
| helm\_chart\_repo | Cert Manager repository name. | `string` | `"https://charts.jetstack.io"` | no |
| helm\_chart\_version | Cert Manager Helm chart version. | `string` | `"1.1.0"` | no |
| http01 | n/a | <pre>list(object({<br>    name           = string<br>    kind           = string<br>    ingress_class  = string<br>    secret_key_ref = string<br>    acme_server    = string<br>    acme_email     = string<br>  }))</pre> | `[]` | no |
| install\_CRDs | To automatically install and manage the CRDs as part of your Helm release. | `bool` | `true` | no |
| mod\_dependency | Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable. | `any` | `null` | no |
| namespace | Kubernetes namespace to deploy Cert Manager Helm chart. | `string` | `"cert-manager"` | no |
| service\_account\_name | External Secrets service account name | `string` | `"cert-manager"` | no |
| settings | Additional settings which will be passed to the Helm chart values. | `map(any)` | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-eks-cert-manager/blob/master/LICENSE) for full details.
