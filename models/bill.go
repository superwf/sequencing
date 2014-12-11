package models

import(
  "net/http"
  "time"
  "strconv"
  "sequencing/config"
)

type Bill struct {
  Id int `json:"id"`
  CreateDate time.Time `json:"create_date"`
  Number int `json:"number"`
  Sn string `json:"sn"`
  Money float64 `json:"money"`
  OtherMoney float64 `json:"other_money"`
  Invoice string `json:"invoice"`
  Status string `json:"status"`
  BillOrder []BillOrder
  Creator
}

func GetBills(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Select("DISTINCT bills.id, bills.sn, bills.create_date, companies.name, bills.money, bills.other_money, bills.invoice, bills.status").Table("bills").Joins("LEFT JOIN bill_orders ON bills.id = bill_orders.bill_id LEFT JOIN orders ON bill_orders.order_id = orders.id LEFT JOIN clients ON orders.client_id = clients.id LEFT JOIN companies ON clients.company_id = companies.id")
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  result := []map[string]interface{}{}
  for rows.Next(){
    var id int
    var sn, company, invoice, status string
    var create_date time.Time
    var money, other_money float64
    rows.Scan(&id, &sn, &create_date, &company, &money, &other_money, &invoice, &status)
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "create_date": create_date,
      "company": company,
      "money": money,
      "other_money": other_money,
      "invoice": invoice,
      "status": status,
    }
    result = append(result, d)
  }
  return result, count
}

// generate sn and init status
func GenerateBillSn(orderIds []int, createDate time.Time)(Bill){
  bill := Bill{CreateDate: createDate, Status: config.BillStatus[0]}
  date := createDate.Format("2006-01-02")
  var number int
  Db.Select("MAX(number)").Table("bills").Where("create_date = ?", date).Row().Scan(&number)
  number = number + 1
  bill.Number = number
  bill.Sn = bill.CreateDate.Format("20060102") + "-" + strconv.Itoa(number)
  return bill
}

func (bill *Bill)BillOrders()([]map[string]interface{}){
  db := Db.Table("bill_orders").Where("bill_orders.bill_id = ?", bill.Id).Select("bill_orders.order_id, orders.sn, clients.name, bill_orders.price, bill_orders.other_money, bill_orders.charge_count, bill_orders.money, orders.remark, bill_orders.remark").Joins("INNER JOIN orders ON bill_orders.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id")
  rows, _ := db.Rows()
  result := []map[string]interface{}{}
  for rows.Next() {
    var order, client, orderRemark, remark string
    var id, chargeCount int
    var price, otherMoney, money float64
    rows.Scan(&id, &order, &client, &price, &otherMoney, &chargeCount, &money, &orderRemark, &remark)
    d := map[string]interface{}{
      "id": id,
      "order": order,
      "client": client,
      "price": price,
      "other_money": otherMoney,
      "charge_count": chargeCount,
      "money": money,
      "order_remark": orderRemark,
      "remark": remark,
    }
    result = append(result, d)
  }
  return result
}

// when bill_orders changed, regenerate money
func (bill *Bill)UpdateMoney(){
  var money, otherMoney float64
  Db.Select("SUM(other_money), SUM(money)").Table("bill_orders").Where("bill_id = ?", bill.Id).Row().Scan(&otherMoney, &money)
  b := Bill{Money: money + otherMoney}
  b.Money = bill.Money + b.OtherMoney
  Db.Model(&bill).UpdateColumns(b)
}

// when created, update orders status to checkout
func (bill *Bill)AfterCreate()(error){
  go func(){
    Db.Exec("UPDATE orders, bill_orders SET orders.status = ? WHERE bill_orders.bill_id = ?", config.OrderStatus[3], bill.Id)
  }()
  return nil
}

// when finish, update orders status to finish
func (bill *Bill)AfterUpdate()(error){
  if bill.Status == config.BillStatus[4] || bill.Status == config.BillStatus[3] {
    go func(){
      Db.Exec("UPDATE orders, bill_orders SET orders.status = ? WHERE bill_orders.bill_id = ?", config.OrderStatus[4], bill.Id)
    }()
  }
  return nil
}
