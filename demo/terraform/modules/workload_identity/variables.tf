# ----------------------------------------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------------------------------------
# GCP Project Name
variable "project_id" {
    type = string
}
# GKE Application Service account
variable "ksa_name" {
    description = "Kubernetes Service Account Name"
    type = string
    default = "boa-ksa"
}

variable "iam_ksa" {
    description = "IAM user for KSA"
    type = string
    default = "boa-gsa"
}

variable "iam_ksa_roles" {
    description = "IAM roles for Kubernetes service account"
    type = list(string)
    default = [
        "cloudtrace.agent",
        "monitoring.metricWriter",
        "cloudsql.client"
    ]
}

variable "boa_namespace" {}