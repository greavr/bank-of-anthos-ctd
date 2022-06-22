output "ksa_name" {
  value = module.workload_identity.ksa-name
}

output "iam_ksa" {
  value = module.workload_identity.iam_ksa
}

output "connection_name" {
  value = module.cloud_sql.sql_connection_name
}