package models

import(
  "time"
  "strconv"
  "errors"
  "net/http"
)

type Order struct {
  Id int `json:"id"`
  ClientId int `json:"client_id"`
  Number int `json:"number"`
  BoardHeadId int `json:"board_head_id"`
  CreateDate time.Time `json:"create_date"`
  Sn string `json:"sn"`
  Urgent bool `json:"urgent"`
  IsTest bool `json:"is_test"`
  TransportCondition string `json:"transport_condition"`
  Status string `json:"status"`
  Remark string `json:"remark"`
  Samples []Sample
  Creator
}

func (record *Order)BeforeSave() error {
  client := Client{Id: record.ClientId}
  Db.First(&client)
  if client.Name == "" {
    return errors.New("client not_exist")
  }
  board_head := BoardHead{}
  Db.Where("available = 1 AND id = ?", record.BoardHeadId).First(&board_head)
  if board_head.Name == "" {
    return errors.New("board_head not_exist")
  }
  // generate sn
  //var max_day_number int
  //Db.Table("orders").Select("MAX(day_number)").Where("create_date = ?", record.CreateDate.Format("2006-01-02")).Row().Scan(&max_day_number)
  record.Sn = record.CreateDate.Format("20060102") + "-" + board_head.Name + strconv.Itoa(record.Number)
  if record.Id == 0 {
    record.Status = "new"
  }
  return nil
}

func GetOrders(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("orders").Select("orders.id, orders.client_id, orders.number, orders.board_head_id, orders.create_date, orders.sn, orders.urgent, orders.is_test, orders.transport_condition, orders.status, orders.remark, clients.name").Joins("INNER JOIN clients ON clients.id = orders.client_id")
  sn := req.FormValue("sn")
  if sn != "" {
    db = db.Where("orders.sn = ?", sn)
  }
  date_from := req.FormValue("date_from")
  if date_from != "" {
    db = db.Where("orders.create_date >= ?", date_from)
  }
  date_to := req.FormValue("date_to")
  if date_to != "" {
    db = db.Where("orders.create_date <= ?", date_to)
  }
  board_head_id := req.FormValue("board_head_id")
  if board_head_id != "" {
    db = db.Where("orders.board_head_id = ?", board_head_id)
  }
  status := req.FormValue("status")
  if status != "" {
    db = db.Where("orders.status = ?", status)
  }
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Order("orders.id DESC").Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var id, client_id, number, board_head_id int
    var sn, transport_condition, status, remark, client string
    var create_date time.Time
    var is_test, urgent bool
    rows.Scan(&id, &client_id, &number, &board_head_id, &create_date, &sn, &urgent, &is_test, &transport_condition, &status, &remark, &client)
    d := map[string]interface{}{
      "id": id,
      "client_id": client_id,
      "number": number,
      "board_head_id": board_head_id,
      "create_date": create_date,
      "sn": sn,
      "urgent": urgent,
      "is_test": is_test,
      "transport_condition": transport_condition,
      "status": status,
      "remark": remark,
      "client": client,
    }
    result = append(result, d)
  }
  return result, count
}
