resource "kubectl_manifest" "http01" {
  count      = length(var.http01)
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ${var.http01[count.index].kind}
metadata:
  name: ${var.http01[count.index].name}
spec:
  acme:
    # The ACME server URL
    server: ${var.http01[count.index].acme_server}
    # Email address used for ACME registration
    email: ${var.http01[count.index].acme_email}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: ${var.http01[count.index].secret_key_ref}
    solvers:
    - http01:
       ingress:
         class: ${var.http01[count.index].ingress_class}
YAML
  depends_on = [helm_release.cert_manager]
}

variable "http01" {
  type = list(object({
    name           = string
    kind           = string
    ingress_class  = string
    secret_key_ref = string
    acme_server    = string
    acme_email     = string
  }))
  default = []
}