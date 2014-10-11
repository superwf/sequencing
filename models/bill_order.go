package models

type BillOrder struct {
  OrderId int `json:"order_id" gorm:"primary_key:yes"`
  BillId int `json:"bill_id"`
  Price float64 `json:"price"`
  ChargeCount int `json:"charge_count"`
  Money float64 `json:"money"`
  OtherMoney float64 `json:"other_money"`
  Remark string `json:"remark"`
}

