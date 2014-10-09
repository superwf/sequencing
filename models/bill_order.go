package models

type BillOrder struct {
  Id int `json:"id"`
  BillId int `json:"bill_id"`
  OrderId int `json:"order_id"`
  Price float64 `json:"price"`
  ChargeCount int `json:"charge_count"`
  Money float64 `json:"money"`
  OtherMoney float64 `json:"other_money"`
  Remark string `json:"remark"`
}
