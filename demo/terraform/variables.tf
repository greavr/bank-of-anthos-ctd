# ----------------------------------------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------------------------------------
# GCP Project Name
variable "project_id" {
    type = string
}

# VPC Demo Network Name
variable "vpc-name" {
    type = string
    description = "Custom VPC Name"
    default = "bank-of-anthos"
}

# List of regions (support for multi-region deployment)
variable "regions" { 
    type = list(object({
        region = string
        cidr = string
        management-cidr = string
        })
    )
    default = [{
            region = "us-west1"
            cidr = "10.0.0.0/20"
            management-cidr = "192.168.10.0/28"
        },]
}

# Service to enable
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "compute.googleapis.com",
        "container.googleapis.com",
        "monitoring.googleapis.com",
        "cloudtrace.googleapis.com",
        "clouddebugger.googleapis.com",
        "cloudprofiler.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "iam.googleapis.com",
        "sourcerepo.googleapis.com",
        "servicenetworking.googleapis.com",
        "sqladmin.googleapis.com"
    ]
  
}


# BOA config
variable "namespace" {
    description = "GKE Namespace"
    type = string
    default = "boa"
}

# ----------------------------------------------------------------------------------------------------------------------
# Optional Vars
# ----------------------------------------------------------------------------------------------------------------------
# variable "project_name" {
#  type        = string
#  description = "project name in which demo deploy"
# }
# variable "project_number" {
#  type        = string
#  description = "project number in which demo deploy"
# }
# variable "gcp_account_name" {
#  description = "user performing the demo"
# }
# variable "deployment_service_account_name" {
#  description = "Cloudbuild_Service_account having permission to deploy terraform resources"
# }
# variable "org_id" {
#  description = "Organization ID in which project created"
# }