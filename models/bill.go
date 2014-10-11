package models

import(
  "net/http"
  "time"
  "strconv"
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
  page := getPage(req)
  db := Db.Select("bills.id, bills.sn, bills.create_date, companies.name, bills.money, bills.other_money").Table("bills").Joins("INNER JOIN bill_orders ON bills.id = bill_orders.bill_id INNER JOIN orders ON bill_orders.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id INNER JOIN companies ON clients.company_id = companies.id")
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  result := []map[string]interface{}{}
  for rows.Next(){
    var id int
    var sn, company string
    var create_date time.Time
    var money, other_money float64
    rows.Scan(&id, &sn, &create_date, &company, &money, &other_money)
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "create_date": create_date,
      "company": company,
      "money": money,
      "other_money": other_money,
    }
    result = append(result, d)
  }
  return result, count
}

// create bill and generate sn
func CreateBill(orderIds []int, createDate time.Time)(Bill){
  bill := Bill{CreateDate: createDate}
  date := createDate.Format("2006-01-02")
  var number int
  Db.Select("MAX(number)").Table("bills").Where("create_date = ?", date).Row().Scan(&number)
  number = number + 1
  bill.Number = number
  bill.Sn = bill.CreateDate.Format("20060102") + "-" + strconv.Itoa(number)
  for _, id := range(orderIds){
    order := Order{Id: id}
    Db.First(&order)
    var count int
    Db.Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id").Where("reactions.order_id = ? AND reaction_files.code_id > 0", id).Count(&count)
    billOrder := BillOrder{
      OrderId: id,
      ChargeCount: count,
    }
    bill.BillOrder = append(bill.BillOrder, billOrder)
  }
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
