# --------------------------------------------------
# テーブル定義
# --------------------------------------------------
# テーブルを追加する場合:
#   1. table_schema/<table_id>.json を追加
#   2. "dataset_id.table_id" = { description = "..." } を追記
# スキーマ変更のみの場合は JSON を更新するだけでOK
locals {
  tables = {
    "raw.table1" = { description = "ユーザーマスタ" }
    "dwh.table2" = { description = "注文トランザクション" }
  }
}
