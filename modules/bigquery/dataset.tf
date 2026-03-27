resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  project     = var.project_id
  dataset_id  = each.key
  description = each.value.description
  location    = var.location
  labels      = { env = var.environment }

  # staging は 48h、prod は 168h (7日) をデフォルトとする
  max_time_travel_hours = each.value.max_time_travel_hours != null ? each.value.max_time_travel_hours : (var.environment == "staging" ? "48" : "168")

  delete_contents_on_destroy = var.environment == "staging" ? true : false

  dynamic "access" {
    for_each = each.value.access
    content {
      role           = access.value.role
      user_by_email  = access.value.user_by_email
      group_by_email = access.value.group_by_email
      special_group  = access.value.special_group
      iam_member     = access.value.iam_member
      domain         = access.value.domain
    }
  }
}
