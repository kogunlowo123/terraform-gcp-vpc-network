locals {
  network_name = var.network_name
  project_id   = var.project_id

  # Build a map of subnets keyed by name for easy lookup
  subnets_map = { for s in var.subnets : s.name => s }

  # Cloud NAT naming defaults
  nat_name    = var.nat_name != "" ? var.nat_name : "${var.network_name}-cloud-nat"
  router_name = "${var.network_name}-router"
  nat_region  = var.nat_region != "" ? var.nat_region : (length(var.subnets) > 0 ? var.subnets[0].region : "us-central1")

  # Firewall rules map keyed by name
  firewall_rules_map = { for r in var.firewall_rules : r.name => r }

  # Private DNS zones map keyed by name
  dns_zones_map = { for z in var.private_dns_zones : z.name => z }

  # Common labels applied to all resources
  common_labels = var.tags
}
