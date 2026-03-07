data "google_project" "current" {
  project_id = var.project_id
}

data "google_compute_zones" "available" {
  for_each = local.subnets_map
  project  = var.project_id
  region   = each.value.region
}
