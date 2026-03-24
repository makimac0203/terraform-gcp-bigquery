# --------------------------------------------------
# ビュー定義
# --------------------------------------------------
# ビューを追加する場合:
#   1. view_query/<view_id>.sql を追加
#   2. "dataset_id.view_id" = { description = "..." } を追記
locals {
  views = {
    "dwh.v_user_orders" = { description = "ユーザー別注文サマリ" }
  }
}
