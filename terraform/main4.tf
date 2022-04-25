# ----------------------------------------------------------------------------------------------------------------------
# CREATE SQL Private Network & Instance
# ----------------------------------------------------------------------------------------------------------------------

## Create Private IP Range
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.demo-vpc.id
  depends_on = [google_compute_network.demo-vpc]
}

## Create VPC peer
resource "google_service_networking_connection" "cloud-sql" {
  network                 = google_compute_network.demo-vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  depends_on = [
    google_compute_global_address.private_ip_alloc,
    google_project_service.enable-services
    ]
}

# Cloud SQL Instance
resource "google_sql_database_instance" "db-primary" {
  provider = google-beta
  name   = "bank-of-anthos-db"       
  database_version = "POSTGRES_12"
  region = var.regions[0].region
  settings {
    tier = "db-custom-1-3840"
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.demo-vpc.id
    }
  }
  depends_on = [google_service_networking_connection.cloud-sql]
}

# Cloud SQL user
resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.db-primary.name
  password = "admin"
  depends_on = [google_sql_database_instance.db-primary]
}
# Cloud SQL DB
resource "google_sql_database" "accounts-db" {
  name     = "accounts-db"
  instance = google_sql_database_instance.db-primary.name
  depends_on = [google_sql_database_instance.db-primary]
}
resource "google_sql_database" "ledger-db" {
  name     = "ledger-db"
  instance = google_sql_database_instance.db-primary.name
  depends_on = [google_sql_database_instance.db-primary]
}