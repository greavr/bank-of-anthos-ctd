output "gke-name" {
    value = google_container_cluster.gke-clusters.name
}

output "gke-region" {
    value = google_container_cluster.gke-clusters.location
}