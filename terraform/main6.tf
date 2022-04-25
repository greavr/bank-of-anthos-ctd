# ----------------------------------------------------------------------------------------------------------------------
# Create Name Space
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "cluster_1" {
  metadata {
    name = var.boa_namespace
  }
  provider =  kubernetes.cluster1
}


# ----------------------------------------------------------------------------------------------------------------------
# Create Service Accounts
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_service_account" "cluster_1" {
    metadata {
        name = var.ksa_name
        namespace = var.boa_namespace
        annotations = {
          "iam.gke.io/gcp-service-account" = "${var.iam_ksa}@${var.project_id}.iam.gserviceaccount.com"
        }
    }

    provider =  kubernetes.cluster1
    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Create Secrets
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_secret" "db_secret" {
    metadata {
        name = "cloud-sql-admin"
        namespace = var.boa_namespace
    }

    data = {
        username = google_sql_user.users.name
        password = google_sql_user.users.password
        connectionName = google_sql_database_instance.db-primary.connection_name
    }
    
    type = "kubernetes.io/generic"
    provider = kubernetes.cluster1
    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}