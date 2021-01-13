variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "helm_chart_name" {
  type        = string
  default     = "cert-manager"
  description = "Cert Manager Helm chart name to be installed"
}

variable "helm_chart_release_name" {
  type        = string
  default     = "cert-manager"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.1.0"
  description = "Cert Manager Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://charts.jetstack.io"
  description = "Cert Manager repository name."
}

variable "install_CRDs" {
  type        = bool
  default     = true
  description = "To automatically install and manage the CRDs as part of your Helm release."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "cert-manager"
  description = "Kubernetes namespace to deploy Cert Manager Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}