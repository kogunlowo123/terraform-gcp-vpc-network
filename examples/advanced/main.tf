module "vpc" {
  source = "../../"

  project_id   = var.project_id
  network_name = "my-advanced-vpc"
  description  = "An advanced VPC network with GKE secondary ranges and Cloud NAT"
  routing_mode = "GLOBAL"
  mtu          = 1460

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
      flow_logs             = false
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
      name      = "deny-all-egress"
      direction = "EGRESS"
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
    nat_ip_allocate_option = "AUTO_ONLY"
    min_ports_per_vm       = 128
    max_ports_per_vm       = 4096
    log_config_enable      = true
    log_config_filter      = "ERRORS_ONLY"
  }

  tags = {
    environment = "staging"
    team        = "platform"
    managed_by  = "terraform"
  }
}
