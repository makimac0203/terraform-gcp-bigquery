terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  # --- Terraform Cloud / remote backend を使う場合はここを調整 ---
  # backend "gcs" {
  #   bucket = "your-tfstate-bucket-staging"
  #   prefix = "terraform/state"
  # }
}

variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
}

locals {
  project_id  = var.project_id
  environment = "staging"
  region      = "asia-northeast1"
}

provider "google" {
  project = local.project_id
  region  = local.region
}

# --------------------------------------------------
# API有効化（共通モジュール）
# --------------------------------------------------
module "apis" {
  source     = "../modules/apis"
  project_id = local.project_id
}

# --------------------------------------------------
# BigQuery（共通モジュール）
# --------------------------------------------------
module "bigquery" {
  source      = "../modules/bigquery"
  project_id  = local.project_id
  environment = local.environment
  location    = local.region
  datasets    = local.datasets
  tables      = local.tables
  views       = local.views

  depends_on = [module.apis]
}
