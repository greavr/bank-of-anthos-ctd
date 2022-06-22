data "terraform_remote_state" "projects" {
    backend = "gcs"
    config = {
        bucket = "bank-of-anthos-ctd"
        prefix = "terraform/state/Project-state"
    }
}
