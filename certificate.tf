resource "kubectl_manifest" "certificate" {
  count      = var.enabled ? length(var.certificates) : 0
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${var.certificates[count.index].name}
  namespace: ${var.certificates[count.index].namespace}
spec:
  secretName: ${var.certificates[count.index].secret_name}
  issuerRef:
    name: ${var.certificates[count.index].issuer_ref}
    kind: ${var.certificates[count.index].kind}
  dnsNames:
  - "${var.certificates[count.index].dns_name}"
YAML
  depends_on = [helm_release.cert_manager]
}

variable "certificates" {
  type = list(object({
    name        = string
    namespace   = string
    secret_name = string
    issuer_ref  = string
    kind        = string
    dns_name    = string
  }))
  default = []
}