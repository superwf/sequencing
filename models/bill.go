package models

import(
  "net/http"
  "time"
)

type Bill struct {
  Id int `json:"id"`
  CreateDate time.Time `json:"create_date"`
  Number int `json:"number"`
  Sn string `json:"sn"`
  Money float64 `json:"money"`
  OtherMoney float64 `json:"other_money"`
  Status string `json:"status"`
  BillOrder []BillOrder
  Creator
}

func GetBills(req *http.Request)([]map[string]interface{}, int){
  result := []map[string]interface{}{}
  return result, 0
}
