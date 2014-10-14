package models

import(
  "net/http"
  "time"
  "sequencing/config"
  "errors"
)

type Email struct {
  Id int `json:"id"`
  RecordId int `json:"record_id"`
  Sent bool `json:"sent"`
  EmailType string `json:"email_type"`
  Remark string `json:"remark"`
  Creator
}

// get the orders those has interpreted reactions
func SendingOrderEmails()([]map[string]interface{}){
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

func GetEmails(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Select("emails.id, emails.record_id, emails.sent, emails.email_type, emails.remark, users.name, emails.created_at, emails.updated_at").Joins("INNER JOIN users ON emails.creator_id = users.id").Table("emails").Order("emails.id DESC")
  var count int
  db.Count(&count)
  records := []map[string]interface{}{}
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  for rows.Next() {
    var id, recordId int
    var sent bool
    var emailType, creator, remark string
    var created_at, updated_at time.Time
    rows.Scan(&id, &recordId, &sent, &emailType, &remark, &creator, &created_at, &updated_at)
    d := map[string]interface{}{
      "id": id,
      "sent": sent,
      "email_type": emailType,
      "creator": creator,
      "remark": remark,
      "created_at": created_at,
      "updated_at": updated_at,
    }
    // primer
    var name, client string
    if emailType == config.EmailType[0] {
      Db.Table("primers").Select("primers.name, clients.name").Joins("INNER JOIN clients ON primers.client_id = clients.id").Where("primers.id = ?", recordId).Row().Scan(&name, &client)
    // order type, include precheck, interprete
    } else {
      Db.Table("orders").Select("orders.sn, clients.name").Joins("INNER JOIN clients ON orders.client_id = clients.id").Where("orders.id = ?", recordId).Row().Scan(&name, &client)
    }
    d["name"] = name
    d["client"] = client
    records = append(records, d)
  }
  return records, count
}

func (email *Email)AfterCreate()(error){
  if email.EmailType == config.EmailType[2] {
    order := Order{Id: email.RecordId}
    go func(){
      order.SubmitInterpretedReactionFiles()
    }()
  }
  return nil
}

// only can be deleted before sent
func (email *Email)BeforeDelete()(error){
  Db.First(email)
  if email.Sent {
    return errors.New("already send")
  } else {
    return nil
  }
}
