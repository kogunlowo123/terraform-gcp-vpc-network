# Terraform GCP VPC Network Module

A Terraform module for creating and managing Google Cloud Platform (GCP) VPC networks with support for custom subnets, secondary ranges for GKE, Private Google Access, Cloud NAT, firewall rules, Shared VPC, and private DNS zones.

## Features

- **Custom VPC Network** with configurable routing mode and MTU
- **Custom Subnets** with secondary IP ranges (for GKE pods and services)
- **Private Google Access** per subnet
- **VPC Flow Logs** per subnet
- **Cloud NAT** with Cloud Router for outbound internet access
- **Firewall Rules** with support for allow/deny, target tags, and service accounts
- **Shared VPC** host project and service project attachment
- **Private DNS Zones** associated with the VPC
- **VPC Access Connectors** for serverless services
- **Default route deletion** option

## Usage

### Basic

```hcl
module "vpc" {
  source = "github.com/kogunlowo123/terraform-gcp-vpc-network"

  project_id   = "my-gcp-project"
  network_name = "my-vpc"

  subnets = [
    {
      name          = "subnet-01"
      region        = "us-central1"
      ip_cidr_range = "10.0.0.0/24"
    },
  ]
}
```

### With GKE Secondary Ranges and Cloud NAT

```hcl
module "vpc" {
  source = "github.com/kogunlowo123/terraform-gcp-vpc-network"

  project_id   = "my-gcp-project"
  network_name = "my-gke-vpc"

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
  ]

  enable_cloud_nat = true
  nat_region       = "us-central1"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 5.10.0 |
| google-beta | >= 5.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | The GCP project ID | `string` | n/a | yes |
| network_name | The name of the VPC network | `string` | n/a | yes |
| description | Description of the VPC network | `string` | `""` | no |
| auto_create_subnetworks | Auto-create subnetworks | `bool` | `false` | no |
| routing_mode | Network routing mode (REGIONAL or GLOBAL) | `string` | `"GLOBAL"` | no |
| mtu | Maximum Transmission Unit (1300-8896) | `number` | `1460` | no |
| subnets | List of subnet configurations | `list(object)` | `[]` | no |
| firewall_rules | List of firewall rule configurations | `list(object)` | `[]` | no |
| enable_cloud_nat | Enable Cloud NAT | `bool` | `true` | no |
| nat_name | Cloud NAT instance name | `string` | `""` | no |
| nat_region | Cloud NAT region | `string` | `""` | no |
| cloud_nat_config | Cloud NAT configuration options | `object` | `{}` | no |
| enable_shared_vpc_host | Enable Shared VPC host project | `bool` | `false` | no |
| shared_vpc_service_projects | Service project IDs for Shared VPC | `list(string)` | `[]` | no |
| private_dns_zones | Private DNS zones to create | `list(object)` | `[]` | no |
| delete_default_routes | Delete default routes on creation | `bool` | `false` | no |
| tags | Labels to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| network_id | The VPC network ID |
| network_name | The VPC network name |
| network_self_link | The VPC network self link |
| subnet_ids | Map of subnet IDs |
| subnet_self_links | Map of subnet self links |
| subnet_ip_cidr_ranges | Map of subnet CIDR ranges |
| subnet_secondary_ranges | Map of subnet secondary ranges |
| router_id | Cloud Router ID |
| nat_id | Cloud NAT ID |
| firewall_rule_ids | Map of firewall rule IDs |
| dns_zone_ids | Map of DNS zone IDs |
| shared_vpc_host_project_id | Shared VPC host project ID |

## Examples

- [Basic](./examples/basic/) - Simple VPC with two subnets
- [Advanced](./examples/advanced/) - VPC with GKE ranges, Cloud NAT, and firewall rules
- [Complete](./examples/complete/) - Full-featured VPC with Shared VPC, DNS, and all options

## License

MIT License. See [LICENSE](./LICENSE) for details.
