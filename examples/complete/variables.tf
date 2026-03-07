variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "service_project_ids" {
  description = "List of service project IDs for Shared VPC."
  type        = list(string)
  default     = []
}
