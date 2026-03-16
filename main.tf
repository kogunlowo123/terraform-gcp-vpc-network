resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  description             = var.description
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  mtu                     = var.mtu

  delete_default_routes_on_create = var.delete_default_routes
}

resource "google_compute_subnetwork" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name                     = each.value.name
  project                  = var.project_id
  region                   = each.value.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = each.value.ip_cidr_range
  private_ip_google_access = each.value.private_google_access

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = each.value.flow_logs ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_router" "router" {
  count = var.enable_cloud_nat ? 1 : 0

  name    = "${var.network_name}-router"
  project = var.project_id
  region  = var.nat_region != "" ? var.nat_region : (length(var.subnets) > 0 ? var.subnets[0].region : "us-central1")
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  count = var.enable_cloud_nat ? 1 : 0

  name                                = var.nat_name != "" ? var.nat_name : "${var.network_name}-cloud-nat"
  project                             = var.project_id
  router                              = google_compute_router.router[0].name
  region                              = var.nat_region != "" ? var.nat_region : (length(var.subnets) > 0 ? var.subnets[0].region : "us-central1")
  nat_ip_allocate_option              = var.cloud_nat_config.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat  = var.cloud_nat_config.source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                    = var.cloud_nat_config.min_ports_per_vm
  max_ports_per_vm                    = var.cloud_nat_config.max_ports_per_vm
  udp_idle_timeout_sec                = var.cloud_nat_config.udp_idle_timeout_sec
  icmp_idle_timeout_sec               = var.cloud_nat_config.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec    = var.cloud_nat_config.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = var.cloud_nat_config.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = var.cloud_nat_config.tcp_time_wait_timeout_sec
  enable_endpoint_independent_mapping = var.cloud_nat_config.enable_endpoint_independent_mapping

  dynamic "log_config" {
    for_each = var.cloud_nat_config.log_config_enable ? [1] : []
    content {
      enable = true
      filter = var.cloud_nat_config.log_config_filter
    }
  }
}

resource "google_compute_firewall" "rules" {
  for_each = { for r in var.firewall_rules : r.name => r }

  name      = each.value.name
  project   = var.project_id
  network   = google_compute_network.vpc.id
  direction = each.value.direction
  priority  = each.value.priority

  source_ranges      = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.ranges : null

  target_tags             = length(each.value.target_tags) > 0 ? each.value.target_tags : null
  target_service_accounts = length(each.value.target_service_accounts) > 0 ? each.value.target_service_accounts : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = length(allow.value.ports) > 0 ? allow.value.ports : null
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = length(deny.value.ports) > 0 ? deny.value.ports : null
    }
  }
}

resource "google_dns_managed_zone" "private_zones" {
  for_each = { for z in var.private_dns_zones : z.name => z }

  name        = each.value.name
  project     = var.project_id
  dns_name    = each.value.dns_name
  description = each.value.description
  labels      = var.labels
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc.id
    }
  }
}

resource "google_compute_shared_vpc_host_project" "host" {
  count = var.enable_shared_vpc_host ? 1 : 0

  project = var.project_id
}

resource "google_compute_shared_vpc_service_project" "service_projects" {
  for_each = var.enable_shared_vpc_host ? toset(var.shared_vpc_service_projects) : toset([])

  host_project    = var.project_id
  service_project = each.value

  depends_on = [google_compute_shared_vpc_host_project.host]
}

resource "google_vpc_access_connector" "connector" {
  for_each = {
    for s in var.subnets : s.name => s
    if length(s.secondary_ranges) > 0
  }

  name          = "${each.key}-connector"
  project       = var.project_id
  region        = each.value.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = null

  subnet {
    name = google_compute_subnetwork.subnets[each.key].name
  }
}
