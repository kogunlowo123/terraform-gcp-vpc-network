output "network_id" {
  description = "The ID of the VPC network."
  value       = google_compute_network.vpc.id
}

output "network_name" {
  description = "The name of the VPC network."
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "The self link of the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Map of subnet resources keyed by subnet name."
  value       = google_compute_subnetwork.subnets
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by subnet name."
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.id }
}

output "subnet_self_links" {
  description = "Map of subnet self links keyed by subnet name."
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.self_link }
}

output "subnet_ip_cidr_ranges" {
  description = "Map of subnet CIDR ranges keyed by subnet name."
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.ip_cidr_range }
}

output "subnet_secondary_ranges" {
  description = "Map of subnet secondary ranges keyed by subnet name."
  value       = { for k, v in google_compute_subnetwork.subnets : k => v.secondary_ip_range }
}

output "router_id" {
  description = "The ID of the Cloud Router (if Cloud NAT is enabled)."
  value       = var.enable_cloud_nat ? google_compute_router.router[0].id : null
}

output "router_name" {
  description = "The name of the Cloud Router (if Cloud NAT is enabled)."
  value       = var.enable_cloud_nat ? google_compute_router.router[0].name : null
}

output "nat_id" {
  description = "The ID of the Cloud NAT instance (if enabled)."
  value       = var.enable_cloud_nat ? google_compute_router_nat.nat[0].id : null
}

output "nat_name" {
  description = "The name of the Cloud NAT instance (if enabled)."
  value       = var.enable_cloud_nat ? google_compute_router_nat.nat[0].name : null
}

output "firewall_rule_ids" {
  description = "Map of firewall rule IDs keyed by rule name."
  value       = { for k, v in google_compute_firewall.rules : k => v.id }
}

output "firewall_rule_self_links" {
  description = "Map of firewall rule self links keyed by rule name."
  value       = { for k, v in google_compute_firewall.rules : k => v.self_link }
}

output "dns_zone_ids" {
  description = "Map of private DNS zone IDs keyed by zone name."
  value       = { for k, v in google_dns_managed_zone.private_zones : k => v.id }
}

output "dns_zone_name_servers" {
  description = "Map of private DNS zone name servers keyed by zone name."
  value       = { for k, v in google_dns_managed_zone.private_zones : k => v.name_servers }
}

output "project_id" {
  description = "The GCP project ID."
  value       = var.project_id
}

output "shared_vpc_host_project_id" {
  description = "The Shared VPC host project ID (if enabled)."
  value       = var.enable_shared_vpc_host ? google_compute_shared_vpc_host_project.host[0].project : null
}
