# Policy
data "aws_iam_policy_document" "kubernetes_cert_manager" {
  count = var.enabled ? 1 : 0

  statement {
    actions = [
      "route53:GetChange"
    ]
    resources = [
      "arn:aws:route53:::change/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }

}

resource "aws_iam_policy" "kubernetes_cert_manager" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-cert-manager"
  path        = "/"
  description = "Policy for cert-manager service"

  policy = data.aws_iam_policy_document.kubernetes_cert_manager[0].json
}

# Role
data "aws_iam_policy_document" "kubernetes_cert_manager_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_cert_manager" {
  count              = var.enabled ? 1 : 0
  name               = "${var.cluster_name}-cert-manager"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_cert_manager_assume[0].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_cert_manager" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.kubernetes_cert_manager[0].name
  policy_arn = aws_iam_policy.kubernetes_cert_manager[0].arn
}