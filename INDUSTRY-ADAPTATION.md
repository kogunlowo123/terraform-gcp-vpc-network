# Industry Adaptation Guide

## Overview
The `terraform-gcp-vpc-network` module creates a GCP VPC network with custom subnets, secondary IP ranges, firewall rules, Cloud NAT, Cloud Router, Shared VPC, private DNS zones, and configurable routing mode. It provides the network foundation for any GCP-based deployment across industries.

## Healthcare
### Compliance Requirements
- HIPAA, HITRUST, HL7 FHIR
### Configuration Changes
- Set `auto_create_subnetworks = false` for custom subnet control over PHI network segments.
- Configure `subnets` with `private_google_access = true` to access Google APIs (Cloud Healthcare API, BigQuery) without public IPs.
- Set `flow_logs = true` on all subnets containing PHI workloads for audit trail requirements.
- Configure `firewall_rules` with explicit ingress/egress rules allowing only FHIR API ports (443) and denying all other traffic.
- Use `target_service_accounts` in firewall rules instead of `target_tags` for stronger identity-based access.
- Set `enable_cloud_nat = true` for private subnet internet access without public IPs.
- Configure `private_dns_zones` for internal service discovery of healthcare microservices.
- Set `delete_default_routes = true` to force all egress through controlled paths.
- Use `enable_shared_vpc_host = true` with `shared_vpc_service_projects` to centralize network administration.
### Example Use Case
A health tech company creates a Shared VPC with private subnets for its FHIR servers, flow logs on all subnets, firewall rules restricting traffic to HTTPS only, Cloud NAT for patch management egress, and private DNS zones for internal service resolution.

## Finance
### Compliance Requirements
- SOX, PCI-DSS, SOC 2
### Configuration Changes
- Configure `subnets` with separate CIDRs for CDE, non-CDE, and management zones.
- Set `flow_logs = true` on CDE subnets for PCI-DSS network monitoring (Requirement 10).
- Configure `firewall_rules` implementing segmentation between CDE and non-CDE networks (PCI-DSS Requirement 1).
- Use `deny` rules with high priority to block unauthorized inter-zone traffic.
- Set `enable_cloud_nat = true` with `cloud_nat_config.log_config_enable = true` for NAT traffic logging.
- Set `routing_mode = "GLOBAL"` for cross-region routing of financial services.
- Configure `secondary_ranges` for GKE pod and service IP ranges in dedicated CDE subnets.
- Use `enable_shared_vpc_host = true` for centralized network governance.
### Example Use Case
A fintech company segments its VPC into CDE subnets with flow logging, non-CDE subnets for internal tools, and management subnets for admin access, with firewall rules enforcing strict east-west traffic controls between segments.

## Government
### Compliance Requirements
- FedRAMP, CMMC, NIST 800-53
### Configuration Changes
- Set `auto_create_subnetworks = false` for explicit subnet control (NIST SC-7).
- Set `flow_logs = true` on all subnets for continuous monitoring (NIST SI-4, AU-12).
- Configure `firewall_rules` implementing boundary protection with default-deny ingress and controlled egress (NIST SC-7).
- Set `delete_default_routes = true` and define explicit routes for controlled traffic flow (NIST SC-7).
- Set `enable_cloud_nat = true` with logging enabled for egress monitoring.
- Set `routing_mode = "REGIONAL"` to restrict traffic within approved regions.
- Configure `private_dns_zones` for internal DNS resolution without public DNS exposure.
- Use `enable_shared_vpc_host = true` for centralized network administration (NIST CM-3).
- Use `target_service_accounts` in firewall rules for identity-based boundary controls.
### Example Use Case
A government contractor deploys a VPC with regional routing, flow logs on all subnets, default-deny firewall rules, Cloud NAT with logging for controlled egress, and private DNS zones for internal service discovery in an Assured Workloads project.

## Retail / E-Commerce
### Compliance Requirements
- PCI-DSS, CCPA/GDPR
### Configuration Changes
- Configure `subnets` with separate CIDRs for web tier (public-facing), application tier, data tier, and payment processing.
- Set `flow_logs = true` on payment and data tier subnets.
- Configure `firewall_rules` allowing HTTPS ingress to web tier, restricting app-to-data communication to specific ports.
- Set `enable_cloud_nat = true` with `cloud_nat_config.max_ports_per_vm = 4096` for high-throughput application servers.
- Configure `secondary_ranges` for GKE clusters hosting e-commerce microservices.
- Set `mtu = 8896` for jumbo frames if using high-throughput data processing.
- Use `private_dns_zones` for internal service discovery across microservices.
### Example Use Case
An e-commerce platform creates subnets for web frontends, microservice backends, payment processors, and databases, with firewall rules permitting only HTTPS between tiers, Cloud NAT with high port allocation for peak traffic, and GKE secondary ranges for containerized services.

## Education
### Compliance Requirements
- FERPA, COPPA
### Configuration Changes
- Configure `subnets` separating student-facing applications from administrative and research workloads.
- Set `private_google_access = true` on all subnets for accessing Google Workspace, Cloud SQL, and Cloud Storage without public IPs.
- Set `flow_logs = true` on subnets hosting student data.
- Configure `firewall_rules` restricting access to student data subnets from only authorized application service accounts.
- Set `enable_cloud_nat = true` for private subnet internet access.
- Configure `private_dns_zones` for campus service discovery.
### Example Use Case
A university deploys separate subnets for its LMS, student portal, and research clusters, with flow logs on student data subnets, firewall rules restricting database access to application service accounts, and Cloud NAT for egress.

## SaaS / Multi-Tenant
### Compliance Requirements
- SOC 2, ISO 27001
### Configuration Changes
- Use `enable_shared_vpc_host = true` with `shared_vpc_service_projects` for per-tenant project isolation sharing a common network.
- Configure `subnets` per tenant or per tenant tier with appropriate CIDR sizing.
- Set `flow_logs = true` on all subnets for SOC 2 network monitoring evidence.
- Configure `firewall_rules` with per-tenant rules restricting cross-tenant traffic.
- Set `enable_cloud_nat = true` for private subnet egress.
- Configure `secondary_ranges` for GKE multi-tenant clusters.
- Use `private_dns_zones` per tenant for DNS isolation.
- Set `routing_mode = "GLOBAL"` for multi-region SaaS deployments.
### Example Use Case
A SaaS provider uses Shared VPC with per-tenant service projects, dedicated subnets per tenant, firewall rules preventing cross-tenant traffic, flow logs for compliance evidence, and global routing for multi-region availability.

## Cross-Industry Best Practices
- Use environment-based configuration by parameterizing `network_name`, `project_id`, and `tags` per environment.
- Always enable encryption in transit by enforcing HTTPS via firewall rules and using private Google access.
- Enable audit logging by setting `flow_logs = true` on security-sensitive subnets.
- Enforce least-privilege access controls by using `target_service_accounts` in firewall rules instead of network tags.
- Implement network segmentation using multiple subnets with explicit firewall rules between them.
- Configure backup and disaster recovery by using `routing_mode = "GLOBAL"` for cross-region failover and Cloud NAT in each region.
