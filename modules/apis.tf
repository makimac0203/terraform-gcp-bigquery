variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "apis" {
  description = "有効化するAPIのマップ。キー=API名, 値=説明"
  type        = map(string)
  default = {
    "bigquery.googleapis.com" = "BigQuery API"
  }
}

resource "google_project_service" "apis" {
  for_each = var.apis

  project                    = var.project_id
  service                    = each.key
  disable_dependent_services = false
  disable_on_destroy         = false
}
