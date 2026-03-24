# GCP BigQuery Terraform

GCP BigQuery のデータセット・テーブル・ビューを Terraform で管理するリポジトリ。

## 技術スタック

- Terraform >= 1.5.0
- hashicorp/google ~> 5.0
- Region: `asia-northeast1`

## プロジェクト構成

```
terraform-gcp-bigquery/
├── .gitignore                   # .terraform/, *.tfstate, *.tfvars を除外
├── gcp-prod/
│   ├── main.tf                  # Provider・module 呼び出し・variable "project_id"
│   ├── bigquery_datasets.tf     # データセット定義（locals のみ）
│   ├── bigquery_tables.tf       # テーブル定義（locals のみ）
│   ├── bigquery_views.tf        # ビュー定義（locals のみ）
│   ├── terraform.tfvars         # プロジェクトID（Git管理外）
│   ├── terraform.tfvars.example # tfvars テンプレート（Git管理対象）
│   ├── table_schema/            # テーブルスキーマ JSON
│   └── view_query/              # ビュークエリ SQL
├── gcp-staging/                 # 同上（staging 用）
└── modules/
    ├── apis.tf                  # GCP API 有効化
    └── bigquery/
        ├── variables.tf
        ├── dataset.tf           # google_bigquery_dataset リソース
        ├── table.tf             # google_bigquery_table リソース
        └── view.tf              # google_bigquery_table (view) リソース
```

## コード規約

### 環境ファイルの役割分担

- `bigquery_datasets.tf` / `bigquery_tables.tf` / `bigquery_views.tf` には **locals の定義のみ** を記述する
- `resource` ブロックは一切書かない（すべて `modules/bigquery/` に集約されている）
- `module "bigquery"` の呼び出しは `main.tf` に書く

### データセット定義

```hcl
# bigquery_datasets.tf
locals {
  datasets = {
    <dataset_id> = { description = "説明" }
  }
}
```

### テーブル定義

キーは `"dataset_id.table_id"` 形式。スキーマは `table_schema/<table_id>.json`。

```hcl
# bigquery_tables.tf
locals {
  tables = {
    "raw.table1" = { description = "説明" }

    # パーティション・クラスタが必要な場合のみ追記
    "dwh.table2" = {
      description       = "説明"
      time_partitioning = { type = "DAY", field = "ordered_at" }
      clustering        = ["user_id"]
    }
  }
}
```

### ビュー定義

キーは `"dataset_id.view_id"` 形式。クエリは `view_query/<view_id>.sql`。

```hcl
# bigquery_views.tf
locals {
  views = {
    "dwh.v_example" = { description = "説明" }
  }
}
```

## リソース追加手順

### データセット追加

1. `bigquery_datasets.tf` の `locals.datasets` にエントリを追加

### テーブル追加

1. `table_schema/<table_id>.json` を作成
2. `bigquery_tables.tf` の `locals.tables` にエントリを追加

### ビュー追加

1. `view_query/<view_id>.sql` を作成
2. `bigquery_views.tf` の `locals.views` にエントリを追加

## コマンド

```bash
cd gcp-staging   # または gcp-prod

# 初回のみ: tfvars をテンプレートからコピーして project_id を設定
cp terraform.tfvars.example terraform.tfvars

terraform init
terraform validate
terraform fmt -check
terraform plan
terraform apply
```

## リソース作成順序

Terraform が依存関係を自動解決し、以下の順で作成する。

```
[1] module.apis               → API 有効化 (bigquery.googleapis.com)
[2] google_bigquery_dataset   → データセット（module.apis に depends_on）
[3] google_bigquery_table     → テーブル（dataset への参照で暗黙的依存）
[4] google_bigquery_table     → ビュー（tables に depends_on）
```

## 環境差分

| 設定 | staging | prod |
|------|---------|------|
| `deletion_protection` | `false` | `true` |
| `delete_contents_on_destroy` | `true` | `false` |

## セキュリティ

- `terraform.tfvars`（プロジェクトIDを含む）は `.gitignore` により Git 管理外
- `*.tfstate` も同様に Git 管理外（ローカルのみ保持）
- リポジトリには `terraform.tfvars.example` のみ含める
- `modules/` 配下に `.terraform/` を置かない（modules は呼び出し元ではないため）
