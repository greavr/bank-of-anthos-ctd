# ----------------------------------------------------------------------------------------------------------------------
# CREATE Cloud SQL Instance
# ----------------------------------------------------------------------------------------------------------------------
resource "google_sql_database_instance" "db-primary" {
  provider = google-beta
  name   = "bank-of-anthos-db"       
  database_version = "POSTGRES_12"
  region = var.region
  settings {
    tier = "db-custom-1-3840"
    ip_configuration {
      ipv4_enabled    = true
      private_network = var.vpc_id
    }
  }
  depends_on = [
    google_service_networking_connection.cloud-sql]

}