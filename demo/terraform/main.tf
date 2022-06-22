# ----------------------------------------------------------------------------------------------------------------------
# Configure Providers
# ----------------------------------------------------------------------------------------------------------------------
provider "google" {
  region        = var.regions[0].region
  project       = var.project_id
}

provider "google-beta" {
  region        = var.regions[0].region
  project       = var.project_id
}

# ----------------------------------------------------------------------------------------------------------------------
# DATA
# ----------------------------------------------------------------------------------------------------------------------
data "google_project" "project" {}
data "google_client_config" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# ORG Policies
# ----------------------------------------------------------------------------------------------------------------------
module "org_policy" {
  source  = "./modules/org_policy"

  project_id = var.project_id
}

# ----------------------------------------------------------------------------------------------------------------------
# Enable APIs
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "enable-services" {
  for_each = toset(var.services_to_enable)

  project = var.project_id
  service = each.value
  disable_on_destroy = false
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure VPC
# ----------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "./modules/vpc"
  project_id = var.project_id
  regions = var.regions
  vpc-name = var.vpc-name
  
  depends_on = [
    google_project_service.enable-services,
    module.org_policy
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure GKE
# ----------------------------------------------------------------------------------------------------------------------
module "gke" {
  for_each = {for a_subnet in var.regions: a_subnet.region => a_subnet}
  source  = "./modules/gke"
  project_id = var.project_id

  vpc-name = var.vpc-name
  region = each.value.region
  management-cidr = each.value.management-cidr
  
  
  depends_on = [
    module.vpc
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure Cloud SQL
# ----------------------------------------------------------------------------------------------------------------------
module "cloud_sql" {
  source  = "./modules/cloud_sql"
  project_id = var.project_id
  vpc_id = module.vpc.vpc_id
  region = module.vpc.primary_region
    
  depends_on = [
    module.vpc
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure Workload Identity
# ----------------------------------------------------------------------------------------------------------------------
module "workload_identity" {
  source  = "./modules/workload_identity"
  project_id = var.project_id
  boa_namespace = var.namespace
  
  
  depends_on = [
    module.vpc
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Map Out GKE Clusters
# ----------------------------------------------------------------------------------------------------------------------
#--GKE Token Lookups
data "google_container_cluster" "gke_cluster" {
    name = "${var.project_id}-us-west1"
    location = "us-west1"
    depends_on = [
      module.gke
    ]
}

provider "kubernetes" {
    host                   = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    cluster_ca_certificate = base64decode("${data.google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate}")
    token                  = data.google_client_config.current.access_token
}

# Same parameters as kubernetes provider
provider "kubectl" {
    load_config_file       = false
    host                   = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    cluster_ca_certificate = base64decode("${data.google_container_cluster.gke_cluster.master_auth.0.cluster_ca_certificate}")
    token                  = data.google_client_config.current.access_token
}


# ----------------------------------------------------------------------------------------------------------------------
# Roll out Yaml
# ----------------------------------------------------------------------------------------------------------------------
module "gke_workload" {
    source = "./modules/gke_workloads"  
    project_id = var.project_id
    namespace = var.namespace
    ksa_name = module.workload_identity.ksa-name
    iam_ksa = module.workload_identity.iam_ksa

    sql_user = module.cloud_sql.sql_user
    sql_pwd = module.cloud_sql.pwd
    sql_connection_name = module.cloud_sql.sql_connection_name


    depends_on = [
      module.gke,
      module.workload_identity,
      data.google_container_cluster.gke_cluster
    ]

}
  

