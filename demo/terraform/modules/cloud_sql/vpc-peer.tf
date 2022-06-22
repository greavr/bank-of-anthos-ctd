# ----------------------------------------------------------------------------------------------------------------------
# CREATE SQL Private Network & Instance
# ----------------------------------------------------------------------------------------------------------------------
## Create Private IP Range
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_id
}

## Create VPC peer
resource "google_service_networking_connection" "cloud-sql" {
  network                 = var.vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  depends_on = [
    google_compute_global_address.private_ip_alloc
    ]
}