module "vpc" {
  source = "../../"

  project_id   = var.project_id
  network_name = "my-complete-vpc"
  description  = "A complete VPC network with all features enabled"
  routing_mode = "GLOBAL"
  mtu          = 1460

  delete_default_routes = true

  subnets = [
    {
      name          = "gke-subnet"
      region        = "us-central1"
      ip_cidr_range = "10.10.0.0/20"
      secondary_ranges = [
        {
          range_name    = "gke-pods"
          ip_cidr_range = "10.20.0.0/14"
        },
        {
          range_name    = "gke-services"
          ip_cidr_range = "10.24.0.0/20"
        },
      ]
      private_google_access = true
      flow_logs             = true
    },
    {
      name                  = "app-subnet"
      region                = "us-central1"
      ip_cidr_range         = "10.30.0.0/24"
      private_google_access = true
      flow_logs             = true
    },
    {
      name                  = "db-subnet"
      region                = "us-east1"
      ip_cidr_range         = "10.40.0.0/24"
      private_google_access = true
      flow_logs             = true
    },
  ]

  firewall_rules = [
    {
      name      = "allow-internal"
      direction = "INGRESS"
      priority  = 1000
      ranges    = ["10.0.0.0/8"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
        },
      ]
    },
    {
      name        = "allow-ssh-iap"
      direction   = "INGRESS"
      priority    = 1000
      ranges      = ["35.235.240.0/20"]
      target_tags = ["allow-ssh"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        },
      ]
    },
    {
      name        = "allow-health-checks"
      direction   = "INGRESS"
      priority    = 1000
      ranges      = ["35.191.0.0/16", "130.211.0.0/22"]
      target_tags = ["allow-health-checks"]
      allow = [
        {
          protocol = "tcp"
        },
      ]
    },
    {
      name      = "deny-all-ingress"
      direction = "INGRESS"
      priority  = 65534
      ranges    = ["0.0.0.0/0"]
      deny = [
        {
          protocol = "all"
        },
      ]
    },
  ]

  enable_cloud_nat = true
  nat_region       = "us-central1"
  cloud_nat_config = {
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    min_ports_per_vm                   = 256
    max_ports_per_vm                   = 8192
    log_config_enable                  = true
    log_config_filter                  = "ERRORS_ONLY"
    enable_endpoint_independent_mapping = false
  }

  enable_shared_vpc_host      = true
  shared_vpc_service_projects = var.service_project_ids

  private_dns_zones = [
    {
      name        = "internal-zone"
      dns_name    = "internal.example.com."
      description = "Internal DNS zone for private services"
    },
    {
      name        = "gke-zone"
      dns_name    = "gke.example.com."
      description = "DNS zone for GKE services"
    },
  ]

  tags = {
    environment = "production"
    team        = "platform"
    cost_center = "engineering"
    managed_by  = "terraform"
  }
}
