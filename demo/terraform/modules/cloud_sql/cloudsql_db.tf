# ----------------------------------------------------------------------------------------------------------------------
# CREATE SQL Databases
# ----------------------------------------------------------------------------------------------------------------------

# Cloud SQL DB
resource "google_sql_database" "accounts-db" {
  name     = "accounts-db"
  instance = google_sql_database_instance.db-primary.name
  depends_on = [
    google_sql_database_instance.db-primary
    ]
}
resource "google_sql_database" "ledger-db" {
  name     = "ledger-db"
  instance = google_sql_database_instance.db-primary.name
  depends_on = [
    google_sql_database_instance.db-primary
    ]
}