package models

import(
  "net/http"
  "time"
)

type Prepayment struct {
  Id int `json:"id"`
  CompanyId int `json:"company_id"`
  CreateDate time.Time `json:"create_date"`
  Money float64 `json:"money"`
  Balance float64 `json:"balance"`
  Invoice string `json:"invoice"`
  Remark string `json:"remark"`
  Creator
}

func (prepayment *Prepayment)BeforeCreate()error{
  prepayment.Balance = prepayment.Money
  return nil
}

func GetPrepayments(req *http.Request)([]Prepayment, int){
  db := Db.Table("prepayments")
  company := req.FormValue("company")
  if company != "" {
    db = db.Joins("INNER JOIN companies ON prepayments.company_id ON companies.id").Where("companies.name LIKE ?", company + "%")
  }
  dateFrom := req.FormValue("date_from")
  if dateFrom != "" {
    db = db.Where("prepayments.create_date >= ?", dateFrom)
  }
  dateTo := req.FormValue("date_to")
  if dateTo != "" {
    db = db.Where("prepayments.create_date <= ?", dateTo)
  }
  balanceFrom := req.FormValue("balance_from")
  if balanceFrom != "" {
    db = db.Where("prepayments.balance > ?", balanceFrom)
  }
  billId := req.FormValue("bill_id")
  if billId != "" {
    db = db.Joins("INNER JOIN prepayment_records ON prepayments.id = prepayment_records.prepayment_id").Where("prepayment_records.bill_id = ?")
  }
  var count int
  db.Count(&count)
  page := getPage(req)
  prepayments := []Prepayment{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&prepayments)
  return prepayments, count
}

// when prepayment_records change, recount the balance
func (p *Prepayment)CountBalance(){
  var money float64
  Db.Select("SELECT SUM(money) FROM prepayment_records").Table("prepayment_records").Where("prepayment_id = ?", p.Id).Row().Scan(&money)
  p.Balance = p.Money - money
  Db.Save(p)
}
