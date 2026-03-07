output "network_id" {
  description = "The VPC network ID."
  value       = module.vpc.network_id
}

output "network_name" {
  description = "The VPC network name."
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "The VPC network self link."
  value       = module.vpc.network_self_link
}

output "subnet_ids" {
  description = "The subnet IDs."
  value       = module.vpc.subnet_ids
}

output "subnet_secondary_ranges" {
  description = "The subnet secondary ranges."
  value       = module.vpc.subnet_secondary_ranges
}

output "nat_name" {
  description = "The Cloud NAT name."
  value       = module.vpc.nat_name
}

output "firewall_rule_ids" {
  description = "The firewall rule IDs."
  value       = module.vpc.firewall_rule_ids
}

output "dns_zone_ids" {
  description = "The private DNS zone IDs."
  value       = module.vpc.dns_zone_ids
}

output "shared_vpc_host_project_id" {
  description = "The Shared VPC host project ID."
  value       = module.vpc.shared_vpc_host_project_id
}
