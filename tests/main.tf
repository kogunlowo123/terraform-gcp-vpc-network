module "test" {
  source = "../"

  project_id   = "test-project-id"
  network_name = "test-vpc-network"
  description  = "Test VPC network"

  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  mtu                     = 1460
  delete_default_routes   = false

  subnets = [
    {
      name                  = "test-subnet-1"
      region                = "us-central1"
      ip_cidr_range         = "10.0.0.0/20"
      private_google_access = true
      flow_logs             = true
      secondary_ranges = [
        {
          range_name    = "pods"
          ip_cidr_range = "10.1.0.0/16"
        },
        {
          range_name    = "services"
          ip_cidr_range = "10.2.0.0/20"
        }
      ]
    },
    {
      name                  = "test-subnet-2"
      region                = "us-east1"
      ip_cidr_range         = "10.4.0.0/20"
      private_google_access = true
      flow_logs             = false
    }
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
          ports    = []
        }
      ]
    },
    {
      name      = "allow-health-checks"
      direction = "INGRESS"
      priority  = 1000
      ranges    = ["35.191.0.0/16", "130.211.0.0/22"]
      allow = [
        {
          protocol = "tcp"
          ports    = []
        }
      ]
      target_tags = ["allow-health-check"]
    }
  ]

  enable_cloud_nat = true
  nat_name         = "test-nat"
  nat_region       = "us-central1"

  cloud_nat_config = {
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    min_ports_per_vm                   = 64
    max_ports_per_vm                   = 4096
    log_config_enable                  = true
    log_config_filter                  = "ERRORS_ONLY"
  }

  private_dns_zones = [
    {
      name        = "test-internal-zone"
      dns_name    = "internal.test.example.com."
      description = "Private DNS zone for internal services"
    }
  ]

  tags = {
    environment = "test"
    managed_by  = "terraform"
  }
}
