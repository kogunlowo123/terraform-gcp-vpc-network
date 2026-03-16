data "google_project" "current" {
  project_id = var.project_id
}

data "google_compute_zones" "available" {
  for_each = { for s in var.subnets : s.name => s }
  project  = var.project_id
  region   = each.value.region
}
