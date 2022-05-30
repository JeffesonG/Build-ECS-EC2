variable "aws_region" {
  type        = string
  description = "Region da AWS"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name"
}


variable "InstanceType" {}

variable "auto_scale_options" {}

variable "auto_scale_cpu" {}

variable "certificateSSL" {}

variable "key-name" {}

variable "ProjectName" {}
variable "container_Port" {}

variable "git_repository_owner" {}
variable "git_repository_name" {}
variable "git_repository_branch" {}
variable "git_token" {}
