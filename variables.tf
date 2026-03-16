variable "project_id" {
  description = "The GCP project ID where the VPC network will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "description" {
  description = "An optional description of the VPC network."
  type        = string
  default     = ""
}

variable "auto_create_subnetworks" {
  description = "Whether to create subnetworks automatically; set to false for custom subnet mode."
  type        = bool
  default     = false
}

variable "routing_mode" {
  description = "The network-wide routing mode (REGIONAL or GLOBAL)."
  type        = string
  default     = "GLOBAL"

  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], var.routing_mode)
    error_message = "routing_mode must be either REGIONAL or GLOBAL."
  }
}

variable "mtu" {
  description = "Maximum Transmission Unit in bytes (1300-8896)."
  type        = number
  default     = 1460

  validation {
    condition     = var.mtu >= 1300 && var.mtu <= 8896
    error_message = "MTU must be between 1300 and 8896."
  }
}

variable "subnets" {
  description = "List of subnet configurations to create within the VPC network."
  type = list(object({
    name          = string
    region        = string
    ip_cidr_range = string
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
    private_google_access = optional(bool, true)
    flow_logs             = optional(bool, false)
  }))
  default = []
}

variable "firewall_rules" {
  description = "List of firewall rules to create for the VPC network."
  type = list(object({
    name      = string
    direction = optional(string, "INGRESS")
    priority  = optional(number, 1000)
    ranges    = optional(list(string), [])
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string), [])
    })), [])
    target_tags             = optional(list(string), [])
    target_service_accounts = optional(list(string), [])
  }))
  default = []
}

variable "enable_cloud_nat" {
  description = "Whether to enable Cloud NAT for the VPC network."
  type        = bool
  default     = true
}

variable "nat_name" {
  description = "The name of the Cloud NAT instance."
  type        = string
  default     = ""
}

variable "nat_region" {
  description = "The region where Cloud NAT and Cloud Router will be created."
  type        = string
  default     = ""
}

variable "cloud_nat_config" {
  description = "Configuration options for Cloud NAT."
  type = object({
    nat_ip_allocate_option              = optional(string, "AUTO_ONLY")
    source_subnetwork_ip_ranges_to_nat  = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES")
    min_ports_per_vm                    = optional(number, 64)
    max_ports_per_vm                    = optional(number, 4096)
    udp_idle_timeout_sec                = optional(number, 30)
    icmp_idle_timeout_sec               = optional(number, 30)
    tcp_established_idle_timeout_sec    = optional(number, 1200)
    tcp_transitory_idle_timeout_sec     = optional(number, 30)
    tcp_time_wait_timeout_sec           = optional(number, 120)
    log_config_enable                   = optional(bool, false)
    log_config_filter                   = optional(string, "ALL")
    enable_endpoint_independent_mapping = optional(bool, false)
  })
  default = {}
}

variable "enable_shared_vpc_host" {
  description = "Whether to enable Shared VPC host project for this network."
  type        = bool
  default     = false
}

variable "shared_vpc_service_projects" {
  description = "List of service project IDs to attach to the Shared VPC host project."
  type        = list(string)
  default     = []
}

variable "private_dns_zones" {
  description = "List of private DNS zones to create and associate with the VPC network."
  type = list(object({
    name        = string
    dns_name    = string
    description = optional(string, "")
  }))
  default = []
}

variable "delete_default_routes" {
  description = "Whether to delete the default routes created by GCP when the network is created."
  type        = bool
  default     = false
}

variable "labels" {
  description = "A map of labels to apply to all resources that support labels."
  type        = map(string)
  default     = {}
}
