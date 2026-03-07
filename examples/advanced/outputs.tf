output "network_id" {
  description = "The VPC network ID."
  value       = module.vpc.network_id
}

output "network_name" {
  description = "The VPC network name."
  value       = module.vpc.network_name
}

output "subnet_ids" {
  description = "The subnet IDs."
  value       = module.vpc.subnet_ids
}

output "nat_name" {
  description = "The Cloud NAT name."
  value       = module.vpc.nat_name
}

output "firewall_rule_ids" {
  description = "The firewall rule IDs."
  value       = module.vpc.firewall_rule_ids
}
