SELECT
  u.id          AS user_id,
  u.user_name,
  o.order_id,
  o.amount,
  o.ordered_at
FROM
  `raw.table1` AS u
  INNER JOIN `dwh.table2` AS o
    ON u.id = o.user_id
