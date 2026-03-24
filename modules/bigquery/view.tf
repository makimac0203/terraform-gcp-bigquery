resource "google_bigquery_table" "views" {
  for_each = var.views

  project    = var.project_id
  dataset_id = google_bigquery_dataset.datasets[split(".", each.key)[0]].dataset_id
  table_id   = split(".", each.key)[1]

  description         = each.value.description
  labels              = merge(each.value.labels, { env = var.environment })
  deletion_protection = false

  view {
    query          = file("${path.root}/view_query/${split(".", each.key)[1]}.sql")
    use_legacy_sql = false
  }

  depends_on = [google_bigquery_table.tables]
}
