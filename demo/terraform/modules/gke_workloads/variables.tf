# ----------------------------------------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------------------------------------
# GCP Project Name
variable "project_id" {
    type = string
}

variable "namespace" {}
variable "ksa_name" {}
variable "iam_ksa" {}
variable "sql_user" {}
variable "sql_pwd" {}
variable "sql_connection_name" {}