# ----------------------------------------------------------------------------------------------------------------------
# OUTPUTS:
# ----------------------------------------------------------------------------------------------------------------------

## Output GKE Connection String
# output "gke_connection_command" {
#  value = [
#   for_each = google_container_cluster.gke-clusters : format("gcloud container clusters get-credentials %s --region %s --project %s",each.value.name,each.value.location,var.project_id)
#  ]
# }


output "deploy_populate_jobs" {
    value = format("kubectl apply -f ../cloudsql/populate-jobs/. -n %s", var.boa_namespace)
}

output "deploy_workloads" {
    value = format("kubectl apply -f ../cloudsql/kubernetes-manifests/. -n %s", var.boa_namespace)
}
