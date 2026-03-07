module "vpc" {
  source = "../../"

  project_id   = var.project_id
  network_name = "my-basic-vpc"
  description  = "A basic VPC network"

  subnets = [
    {
      name          = "subnet-01"
      region        = "us-central1"
      ip_cidr_range = "10.0.0.0/24"
    },
    {
      name          = "subnet-02"
      region        = "us-east1"
      ip_cidr_range = "10.0.1.0/24"
    },
  ]

  enable_cloud_nat = false

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
