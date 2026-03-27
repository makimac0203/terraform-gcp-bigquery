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
| [google_project_service.apis](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apis"></a> [apis](#input\_apis) | 有効化するAPIのマップ。キー=API名, 値=説明 | `map(string)` | <pre>{<br/>  "bigquery.googleapis.com": "BigQuery API"<br/>}</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCPプロジェクトID | `string` | n/a | yes |
## Outputs

No outputs.
<!-- END_TF_DOCS -->