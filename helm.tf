resource "helm_release" "cert_manager" {
  depends_on = [var.mod_dependency, kubernetes_namespace.cert_manager]
  count      = var.enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace

  set {
    name  = "installCRDs"
    value = var.install_CRDs
  }

  dynamic "set" {
    for_each = var.settings

    content {
      name  = set.key
      value = set.value
    }
  }

}