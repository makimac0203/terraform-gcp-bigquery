# terraform-gcp-bigquery

GCP BigQuery のデータセット・テーブル・ビューを Terraform で管理するリポジトリ。

## 構成

```
terraform-gcp-bigquery/
├── gcp-prod/                    # 本番環境
│   ├── main.tf                  # Provider・モジュール呼び出し
│   ├── bigquery_datasets.tf     # データセット定義
│   ├── bigquery_tables.tf       # テーブル定義
│   ├── bigquery_views.tf        # ビュー定義
│   ├── terraform.tfvars         # プロジェクトID等（Git管理外）
│   ├── terraform.tfvars.example # tfvars のテンプレート
│   ├── table_schema/            # テーブルスキーマ (JSON)
│   │   └── <table_id>.json
│   └── view_query/              # ビュークエリ (SQL)
│       └── <view_id>.sql
│
├── gcp-staging/                 # ステージング環境
│   ├── main.tf
│   ├── bigquery_datasets.tf
│   ├── bigquery_tables.tf
│   ├── bigquery_views.tf
│   ├── terraform.tfvars         # プロジェクトID等（Git管理外）
│   ├── terraform.tfvars.example # tfvars のテンプレート
│   ├── table_schema/
│   └── view_query/
│
├── .terraform-docs.yml          # terraform-docs 設定
└── modules/
    ├── apis/
    │   ├── apis.tf              # GCP API 有効化
    │   └── README.md            # terraform-docs 自動生成
    └── bigquery/
        ├── variables.tf         # 入力変数
        ├── dataset.tf           # google_bigquery_dataset リソース
        ├── table.tf             # google_bigquery_table リソース
        ├── view.tf              # google_bigquery_table (view) リソース
        └── README.md            # terraform-docs 自動生成
```

## セットアップ

```bash
cd gcp-staging   # または gcp-prod

# tfvars をテンプレートからコピーしてプロジェクトIDを設定
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars を編集して project_id を設定

terraform init
```

## 環境

| 項目 | staging | prod |
|------|---------|------|
| Region | `asia-northeast1` | `asia-northeast1` |
| テーブル削除保護 | 無効 | 有効 |
| `delete_contents_on_destroy` | `true` | `false` |

## リソース定義の書き方

### データセット (`bigquery_datasets.tf`)

```hcl
locals {
  datasets = {
    raw = { description = "取り込み直後の生データ" }
    dwh = { description = "加工済みデータウェアハウス" }
  }
}
```

### テーブル (`bigquery_tables.tf`)

キーは `"dataset_id.table_id"` 形式。スキーマは `table_schema/<table_id>.json` に定義する。

```hcl
locals {
  tables = {
    "raw.table1" = { description = "ユーザーマスタ" }
    "dwh.table2" = { description = "注文トランザクション" }
  }
}
```

パーティション・クラスタリングが必要な場合はオプションで追記する。

```hcl
"dwh.table2" = {
  description       = "注文トランザクション"
  time_partitioning = { type = "DAY", field = "ordered_at" }
  clustering        = ["user_id"]
}
```

### ビュー (`bigquery_views.tf`)

キーは `"dataset_id.view_id"` 形式。クエリは `view_query/<view_id>.sql` に定義する。

```hcl
locals {
  views = {
    "dwh.v_user_orders" = { description = "ユーザー別注文サマリ" }
  }
}
```

## リソース追加手順

### データセットを追加する

1. `bigquery_datasets.tf` の `locals.datasets` にエントリを追加

### テーブルを追加する

1. `table_schema/<table_id>.json` にスキーマを追加
2. `bigquery_tables.tf` の `locals.tables` にエントリを追加

### ビューを追加する

1. `view_query/<view_id>.sql` にクエリを追加
2. `bigquery_views.tf` の `locals.views` にエントリを追加

## デプロイ手順

```bash
cd gcp-staging   # または gcp-prod

terraform init
terraform validate
terraform plan
terraform apply
```

> `terraform.tfvars` はGit管理外（`.gitignore` 済み）。初回は `terraform.tfvars.example` をコピーして作成すること。

## ドキュメント生成

[terraform-docs](https://terraform-docs.io/) でモジュールの `README.md` を自動生成できる。

```bash
# 特定モジュール
terraform-docs modules/bigquery/

# 全モジュールまとめて
for d in modules/*/; do terraform-docs "$d"; done
```

## リソース作成順序

Terraform が自動的に依存関係を解決し、以下の順序でリソースを作成する。

```
[1] GCP API 有効化 (bigquery.googleapis.com)
      ↓ depends_on
[2] データセット作成
      ↓ 暗黙的依存（リソース参照）
[3] テーブル作成
      ↓ depends_on
[4] ビュー作成
```
