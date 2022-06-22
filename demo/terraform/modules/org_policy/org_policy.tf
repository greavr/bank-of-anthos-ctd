# ----------------------------------------------------------------------------------------------------------------------
# Organization policy
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_organization_policy" "gke-vpc-peering" {
    project = var.project_id
    constraint = "compute.restrictVpcPeering"

    list_policy {
        allow {
            all = true
        }
    }
}

resource "time_sleep" "wait_X_seconds" {
    depends_on = [
        google_project_organization_policy.gke-vpc-peering
        ]

    create_duration = var.time_sleep
}