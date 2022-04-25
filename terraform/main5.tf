# ----------------------------------------------------------------------------------------------------------------------
# Workload Identity GCP Setup
# ----------------------------------------------------------------------------------------------------------------------
# Kubernets service account creation in IAM
resource "google_service_account" "gke_ksa_iam" {
    account_id   = var.iam_ksa
    display_name = var.iam_ksa
    depends_on = [
        google_project_service.enable-services,
        google_container_cluster.gke-clusters
        ]
}

#Bind Workload Identity permissions
resource "google_service_account_iam_member" "ksa_service_account_iap" {
    service_account_id = "${google_service_account.gke_ksa_iam.name}"
    role    = "roles/iam.workloadIdentityUser"
    member  = "serviceAccount:${var.project_id}.svc.id.goog[${var.boa_namespace}/${var.ksa_name}]"
    depends_on = [
        google_service_account.gke_ksa_iam
    ]
}

# Bind GCP Permissions
resource "google_project_iam_member" "ksa_service_account_roles" {
    for_each = toset(var.iam_ksa_roles)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.gke_ksa_iam.email}"
    depends_on = [
        google_service_account.gke_ksa_iam
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Map Out GKE Clusters
# ----------------------------------------------------------------------------------------------------------------------
#--GKE Cluster Lookups
data "google_client_config" "current" {
}

#--GKE Token Lookups
data "google_container_cluster" "gke_cluster_1" {
    name = google_container_cluster.gke-clusters[var.regions[0].region].name
    location = google_container_cluster.gke-clusters[var.regions[0].region].location
    depends_on = [
      google_container_cluster.gke-clusters
    ]
}

provider "kubernetes" {
    host                   = "https://${data.google_container_cluster.gke_cluster_1.endpoint}"
    cluster_ca_certificate = base64decode("${data.google_container_cluster.gke_cluster_1.master_auth.0.cluster_ca_certificate}")
    token                  = data.google_client_config.current.access_token
    alias = "cluster1"
}
