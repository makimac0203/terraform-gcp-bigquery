resource "google_bigquery_table" "tables" {
  for_each = var.tables

  project    = var.project_id
  dataset_id = google_bigquery_dataset.datasets[split(".", each.key)[0]].dataset_id
  table_id   = split(".", each.key)[1]

  description              = each.value.description
  labels                   = merge(each.value.labels, { env = var.environment })
  schema                   = file("${path.root}/table_schema/${split(".", each.key)[1]}.json")
  deletion_protection      = var.environment == "prod" ? true : false
  require_partition_filter = each.value.require_partition_filter

  dynamic "time_partitioning" {
    for_each = each.value.time_partitioning != null ? [each.value.time_partitioning] : []
    content {
      type  = time_partitioning.value.type
      field = time_partitioning.value.field
    }
  }

  clustering = length(each.value.clustering) > 0 ? each.value.clustering : null
}
