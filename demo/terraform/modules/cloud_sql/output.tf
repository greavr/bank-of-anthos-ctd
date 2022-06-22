# ----------------------------------------------------------------------------------------------------------------------
# Outputs
# ----------------------------------------------------------------------------------------------------------------------
output "sql_user" {
  description = "Cloud SQL Internal DB User" 
  value = google_sql_user.users.name
}

output "pwd" {
  description = "Cloud SQL Internal DB User PWD" 
  value = google_sql_user.users.password
  sensitive = true
}

output "sql_ip" {
    description = "Cloud SQL instance IP"
    value = google_sql_database_instance.db-primary.ip_address
}

output "sql_connection_name" {
    description = "Cloud SQL instance IP"
    value = google_sql_database_instance.db-primary.connection_name
}
