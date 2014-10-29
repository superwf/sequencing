package models

import(
  "time"
  "net/http"
)

type PrepaymentRecord struct {
  Id int `json:"id"`
  PrepaymentId int `json:"prepayment_id"`
  BillId int `json:"bill_id"`
  CreateDate time.Time `json:"create_date"`
  Money float64 `json:"money"`
  Remark string `json:"remark"`
  Creator
}

func GetPrepaymentRecords(req *http.Request)([]map[string]interface{}, int){
  result := []map[string]interface{}{}
  db := Db.Select("prepayment_records.id, companies.name, prepayment_records.money, prepayment_records.remark, bills.sn").Table("prepayment_records").Joins("INNER JOIN prepayments ON prepayment_records.prepayment_id = prepayments.id INNER JOIN companies ON prepayments.company_id = companies.id INNER JOIN bills ON prepayment_records.bill_id = bills.id")
  billId := req.FormValue("bill_id")
  if billId != "" {
    db = db.Where("prepayment_records.bill_id = ?", billId)
  }
  prepaymentId := req.FormValue("prepayment_id")
  if prepaymentId != "" {
    db = db.Where("prepayment_records.prepayment_id = ?", prepaymentId)
  }
  rows, _ := db.Rows()
  for rows.Next() {
    var bill, company, remark string
    var money float64
    var id int
    rows.Scan(&id, &company, &money, &remark, &bill)
    d := map[string]interface{}{
      "id": id,
      "company": company,
      "bill": bill,
      "money": money,
      "remark": remark,
    }
    result = append(result, d)
  }
  return result, 0
}

func (r *PrepaymentRecord)BeforeCreate()error{
  r.CreateDate = time.Now()
  return nil
}
func (r *PrepaymentRecord)AfterSave()error{
  go func(){
    p := Prepayment{Id: r.PrepaymentId}
    pp := &p
    Db.First(pp)
    pp.CountBalance()
  }()
  return nil
}
func (r *PrepaymentRecord)AfterDelete()error{
  go func(){
    p := Prepayment{Id: r.PrepaymentId}
    pp := &p
    Db.First(pp)
    pp.CountBalance()
  }()
  return nil
}
