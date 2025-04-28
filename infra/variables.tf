variable "project_name" {
  type    = string
  default = "searchkick-playground"
}

variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "database_username" {
  type    = string
  default = "app"
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "database_name" {
  type    = string
  default = "searchkick_playground"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "opensearch_cluster_instance_type" {
  type        = string
  description = "The OpenSearch cluster instance type"
  default     = "t3.small.search"
}

variable "opensearch_cluster_instance_count" {
  type        = number
  description = "The number of instances of OpenSearch cluster"
  default     = 1
}

variable "opensearch_ebs_volume_size" {
  type        = number
  description = "The size (in GB) of the OpenSearch EBS volume"
  default     = 10
}

variable "github_repository" {
  type        = string
  description = "The GitHub repository in the format 'owner/repo', e.g., 'k0kishima/searchkick-playground'"
}

variable "backend_ecs_service_initial_desired_count" {
  type    = number
  default = 1
}

variable "backend_ecs_task_cpu" {
  type    = number
  default = 512
}

variable "backend_ecs_task_memory" {
  type    = number
  default = 1024
}
