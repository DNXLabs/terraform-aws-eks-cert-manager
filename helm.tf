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

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.kubernetes_cert_manager[0].arn
  }

  set {
    name  = "securityContext.fsGroup.enabled"
    value = true
  }

  set {
    name  = "securityContext.fsGroup"
    value = 1001
  }

  values = [
    yamlencode(var.settings)
  ]

}