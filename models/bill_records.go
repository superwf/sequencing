package models

type BillRecord struct {
  BillId int `json:"bill_id" gorm:"primary_key:yes"`
  Data string `json:"data"`
  Creator
}
