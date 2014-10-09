package models

import(
  "net/http"
  "time"
)

type OrderMail struct {
  Id int `json:"id"`
  OrderId int `json:"order_id"`
  Sent bool `json:"sent"`
  MailType string `json:"mail_type"`
  Remark string `json:"remark"`
  Creator
}

func SendingOrderMails()([]map[string]interface{}){
  rows, _ := Db.Select("DISTINCT clients.name, orders.sn, orders.id").Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN orders ON samples.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id").Where("reaction_files.status = 'interpreted'").Rows()
  result := []map[string]interface{}{}
  for rows.Next() {
    var client, order string
    var orderId int
    rows.Scan(&client, &order, &orderId)
    d := map[string]interface{}{
      "client": client,
      "order": order,
      "id": orderId,
    }
    result = append(result, d)
  }
  return result
}

func GetOrderMails(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Select("order_mails.id, orders.sn, clients.name, order_mails.mail_type, order_mails.sent, users.name, order_mails.remark, order_mails.created_at, order_mails.updated_at").Table("order_mails").Joins("INNER JOIN orders ON order_mails.order_id = orders.id INNER JOIN clients ON orders.client_id = clients.id INNER JOIN users ON order_mails.creator_id = users.id").Order("order_mails.id DESC")
  order := req.FormValue("order")
  if order != "" {
    db = db.Where("orders.sn = ?", order)
  }
  var count int
  db.Count(&count)
  records := []map[string]interface{}{}
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  for rows.Next() {
    var id int
    var sent bool
    var order, client, mailType, creator, remark string
    var created_at, updated_at time.Time
    rows.Scan(&id, &order, &client, &mailType, &sent, &creator, &remark, &created_at, &updated_at)
    d := map[string]interface{}{
      "id": id,
      "sent": sent,
      "order": order,
      "client": client,
      "mail_type": mailType,
      "creator": creator,
      "remark": remark,
      "created_at": created_at,
      "updated_at": updated_at,
    }
    records = append(records, d)
  }
  return records, count
}
