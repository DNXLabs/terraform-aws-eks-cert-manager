resource "kubectl_manifest" "dns01" {
  count      = var.enabled ? length(var.dns01) : 0
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ${var.dns01[count.index].kind}
metadata:
  name: ${var.dns01[count.index].name}
  namespace: ${var.dns01[count.index].namespace}
spec:
  acme:
    # The ACME server URL
    server: ${var.dns01[count.index].acme_server}
    # Email address used for ACME registration
    email: ${var.dns01[count.index].acme_email}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: ${var.dns01[count.index].secret_key_ref}
    solvers:
    - selector:
        dnsZones:
          - "${var.dns01[count.index].dns_zone}"
      dns01:
        route53:
          region: ${var.dns01[count.index].region}
YAML
  depends_on = [helm_release.cert_manager]
}

variable "dns01" {
  type = list(object({
    name           = string
    namespace      = string
    kind           = string
    dns_zone       = string
    region         = string
    secret_key_ref = string
    acme_server    = string
    acme_email     = string
  }))
  default = []
}