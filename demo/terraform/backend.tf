terraform {
backend "gcs" {
bucket = "bank-of-anthos-ctd"
prefix = "terraform/state/Sample_Demo_state"
}
}
