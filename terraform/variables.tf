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

# Extra GKE SA Roles
variable "gke_service_account_roles" {
    description = "GKE Service Account Roles"
    type        = list(string)
    default     = [
        "gkehub.connect",
        "gkehub.admin",
        "logging.logWriter",
        "monitoring.metricWriter",
        "monitoring.dashboardEditor",
        "stackdriver.resourceMetadata.writer",
        "opsconfigmonitoring.resourceMetadata.writer",
        "multiclusterservicediscovery.serviceAgent",
        "multiclusterservicediscovery.serviceAgent",
        "compute.networkViewer",
        "container.admin",
        "source.reader"
    ]
}

# GKE Settings
variable "gke-node-count" {
    description = "GKE Inital Node Count"
    type = number
    default = 2
}

variable "gke-node-type" {
    description = "GKE Node Machine Shape"
    type = string
    default = "e2-standard-4"
}

# BOA config
variable "boa_namespace" {
    description = "GKE Namespace for Bank of Anthos"
    type = string
    default = "boa"
}

# GKE Application Service account
variable "ksa_name" {
    description = "Kubernetes Service Account Name"
    type = string
    default = "boa-ksa"
}

variable "iam_ksa" {
    description = "IAM user for KSA"
    type = string
    default = "boa-gsa"
}

variable "iam_ksa_roles" {
    description = "IAM roles for Kubernetes service account"
    type = list(string)
    default = [
        "cloudtrace.agent",
        "monitoring.metricWriter",
        "cloudsql.client"
    ]
}
