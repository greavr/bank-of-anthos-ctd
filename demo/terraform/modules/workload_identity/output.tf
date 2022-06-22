output "ksa-email" {
    description = "Kubernetes service account configured for workload identity"
    value = google_service_account.gke_ksa_iam.email  
}

output "ksa-name" {
    description = "Name of the kubernetes service account"
    value = var.ksa_name
}

output "iam_ksa" {
    description = "Name of the IAM user created"
    value = var.iam_ksa
}