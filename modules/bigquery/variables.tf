variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "environment" {
  description = "環境名 (staging / prod)"
  type        = string
}

variable "location" {
  description = "BigQueryデータセットのロケーション"
  type        = string
}

variable "datasets" {
  description = "データセット定義マップ"
  type = map(object({
    description = string
  }))
}

variable "tables" {
  description = "テーブル定義マップ。キーは \"dataset_id.table_id\" 形式"
  type = map(object({
    description = string
    time_partitioning = optional(object({
      type  = string
      field = string
    }))
    clustering = optional(list(string), [])
    labels     = optional(map(string), {})
  }))
}

variable "views" {
  description = "ビュー定義マップ。キーは \"dataset_id.view_id\" 形式"
  type = map(object({
    description = string
    labels      = optional(map(string), {})
  }))
  default = {}
}
