resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  project     = var.project_id
  dataset_id  = each.key
  description = each.value.description
  location    = var.location
  labels      = { env = var.environment }

  delete_contents_on_destroy = var.environment == "staging" ? true : false
}
