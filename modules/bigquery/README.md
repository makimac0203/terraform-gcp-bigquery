<!-- BEGIN_TF_DOCS -->

## Requirements

No requirements.
## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
## Modules

No modules.
## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.datasets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_table.tables](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_bigquery_table.views](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datasets"></a> [datasets](#input\_datasets) | データセット定義マップ | <pre>map(object({<br/>    description = string<br/>  }))</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | 環境名 (staging / prod) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | BigQueryデータセットのロケーション | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCPプロジェクトID | `string` | n/a | yes |
| <a name="input_tables"></a> [tables](#input\_tables) | テーブル定義マップ。キーは "dataset\_id.table\_id" 形式 | <pre>map(object({<br/>    description = string<br/>    time_partitioning = optional(object({<br/>      type  = string<br/>      field = string<br/>    }))<br/>    clustering = optional(list(string), [])<br/>    labels     = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_views"></a> [views](#input\_views) | ビュー定義マップ。キーは "dataset\_id.view\_id" 形式 | <pre>map(object({<br/>    description = string<br/>    labels      = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
## Outputs

No outputs.
<!-- END_TF_DOCS -->