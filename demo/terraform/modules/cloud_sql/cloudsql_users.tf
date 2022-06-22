# ----------------------------------------------------------------------------------------------------------------------
# CREATE Cloud SQL Internal User
# ----------------------------------------------------------------------------------------------------------------------
resource "random_password" "password" {
  length           = 16
  special          = false
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.db-primary.name
  password = random_password.password.result
  depends_on = [
    google_sql_database_instance.db-primary
    ]
}