variable "project_id" {
 description = "project id in which demo deploy"
}

variable "time_sleep" {
  description = "Sleep time to wait for org policy to take effect, minimum 60s"
  default = "90s"
}