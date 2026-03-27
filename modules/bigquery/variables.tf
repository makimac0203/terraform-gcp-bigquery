variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "environment" {
  description = "環境名 (staging / prod)"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "environment は staging または prod のみ指定可能です。"
  }
}

variable "location" {
  description = "BigQueryデータセットのロケーション"
  type        = string
}

variable "datasets" {
  description = "データセット定義マップ"
  type = map(object({
    description           = string
    max_time_travel_hours = optional(string)
    access = optional(list(object({
      role           = optional(string)
      user_by_email  = optional(string)
      group_by_email = optional(string)
      special_group  = optional(string)
      iam_member     = optional(string)
      domain         = optional(string)
    })), [])
  }))
}

variable "tables" {
  description = "テーブル定義マップ。キーは \"dataset_id.table_id\" 形式"
  type = map(object({
    description              = string
    require_partition_filter = optional(bool, false)
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
