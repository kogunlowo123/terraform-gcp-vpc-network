# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added

- Initial release of the GCP VPC Network Terraform module
- VPC network creation with configurable routing mode and MTU
- Custom subnet support with secondary IP ranges for GKE
- Private Google Access per subnet
- VPC Flow Logs per subnet
- Cloud NAT with Cloud Router
- Firewall rules with allow/deny, target tags, and service accounts
- Shared VPC host project and service project attachment
- Private DNS managed zones
- VPC Access Connectors for serverless services
- Option to delete default routes on network creation
- Resource labeling support
- Basic, advanced, and complete usage examples
