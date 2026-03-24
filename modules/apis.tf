variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "apis" {
  description = "有効化するAPIのリスト"
  type        = list(string)
  default = [
    "bigquery.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(var.apis)

  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}
