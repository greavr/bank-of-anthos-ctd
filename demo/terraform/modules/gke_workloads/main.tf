# ----------------------------------------------------------------------------------------------------------------------
# Create Name Space
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "cluster_1" {
  metadata {
    name = var.namespace
  }
}


# ----------------------------------------------------------------------------------------------------------------------
# Create Service Accounts
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_service_account" "cluster_1" {
    metadata {
        name = var.ksa_name
        namespace = var.namespace
        annotations = {
          "iam.gke.io/gcp-service-account" = "${var.iam_ksa}@${var.project_id}.iam.gserviceaccount.com"
        }
    }

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
        namespace = var.namespace
    }

    data = {
        username = var.sql_user
        password = var.sql_pwd
        connectionName = var.sql_connection_name
    }
    
    type = "kubernetes.io/generic"
    
    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}

resource "kubernetes_config_map" "ledger-db-config" {
    metadata {
        name = "ledger-db-config"
        namespace = var.namespace
        labels = {
          "app" = "postgres"
        }
    }

    data = {
        POSTGRES_USER = var.sql_user
        POSTGRES_PASSWORD = var.sql_pwd
        POSTGRES_DB = "postgresdb"
        SPRING_DATASOURCE_PASSWORD = var.sql_pwd
        SPRING_DATASOURCE_URL = "jdbc:postgresql://127.0.0.1:5432/ledger-db"
        SPRING_DATASOURCE_USERNAME = var.sql_user
    }
    
    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}

resource "kubernetes_config_map" "accounts-db" {
  metadata {
    name = "accounts-db-config" 
    namespace = var.namespace
    labels = {
      "app" = "accounts-db"
    }
  }
  
  data = {
    "ACCOUNTS_DB_URI" = "postgresql://${var.sql_user}:${var.sql_pwd}@127.0.0.1:5432/accounts-db"
  }

  depends_on = [
      kubernetes_namespace.cluster_1
    ]

}