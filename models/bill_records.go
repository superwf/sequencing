package models

type BillRecord struct {
  Id int `json:"id"`
  BillId int `json:"bill_id"`
  Flow string `json:"flow"`
  Data string `json:"data"`
  Creator
}
