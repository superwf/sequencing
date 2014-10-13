package models

import(
  "log"
  "time"
  "strconv"
  "errors"
  "net/http"
  "sequencing/config"
)

// status is new run checkout finish
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

// generate sn
func (record *Order)BeforeCreate() error {
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

func (record *Order)BeforeDelete()error{
  Db.First(record)
  log.Println(record.Status)
  if record.Status != "new" {
    return errors.New("status error")
  }
  return nil
}

// relate reactions order_id
func (order *Order)RelateReactions(){
  Db.Exec("UPDATE samples, reactions SET reactions.order_id = samples.order_id WHERE samples.order_id = ?", order.Id)
}

func (order *Order)InterpretedReactionFiles()([]map[string]interface{}){
  result := []map[string]interface{}{}
  rows, _ := Db.Select("reactions.id, samples.name, primers.name, precheck_codes.code, precheck_codes.remark, prechecker.name, interprete_codes.code, interprete_codes.result, interprete_codes.remark, interpreter.name").Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN primers ON reactions.primer_id = primers.id INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN prechecks ON samples.id = prechecks.sample_id INNER JOIN precheck_codes ON prechecks.code_id = precheck_codes.id INNER JOIN users AS prechecker ON prechecker.id = prechecks.creator_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id INNER JOIN users AS interpreter ON reaction_files.interpreter_id = interpreter.id").Where("samples.order_id = ? AND reaction_files.status = 'interpreted'", order.Id).Rows()
  for rows.Next(){
    var id int
    var sample, primer, precheckCode, precheckRemark, prechecker, interpreteCode, interpreteResult, interpreteRemark, interpreter string
    rows.Scan(&id, &sample, &primer, &precheckCode, &precheckRemark, &prechecker, &interpreteCode, &interpreteResult, &interpreteRemark, &interpreter)
    d := map[string]interface{}{
      "id": id,
      "sample": sample,
      "primer": primer,
      "precheck_code": precheckCode,
      "precheck_Remark": precheckRemark,
      "prechecker": prechecker,
      "interpreteCode": interpreteCode,
      "interpreteResult": interpreteResult,
      "interpreteRemark": interpreteRemark,
      "interpreter": interpreter,
    }
    result = append(result, d)
  }
  return result
}

// when sent, the order should can checkout
func (order *Order)SubmitInterpretedReactionFiles(){
  Db.Exec("UPDATE reaction_files, reactions, samples SET reaction_files.status = 'sent' WHERE samples.order_id = ? AND samples.id = reactions.sample_id AND reactions.id = reaction_files.reaction_id AND reaction_files.status = 'interpreted'", order.Id)
  Db.First(order)
  order.CheckStatus()
}

func (order *Order)Reinterprete(){
  Db.Exec("UPDATE reaction_files, reactions, samples SET reaction_files.status = 'interpreting' WHERE samples.order_id = ? AND samples.id = reactions.sample_id AND reactions.id = reaction_files.reaction_id AND reaction_files.status = 'interpreted'", order.Id)
}

func (order *Order)CheckStatus() {
  if order.Status == "" && order.Id > 0 {
    Db.First(order)
  }
  switch order.Status {
    case "new":
      var count int
      Db.Table("samples").Joins("INNER JOIN boards ON samples.board_id = boards.id").Where("boards.status <> 'new' AND samples.order_id = ?", order.Id).Limit(1).Count(&count)
      if count > 0 {
        Db.Model(order).Update("status", "run")
      }
    case "run":
      var reactionCount int
      var interpretedCount int
      Db.Table("reactions").Where("reactions.order_id = ?", order.Id).Count(&reactionCount)
      Db.Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id").Where("reaction_files.status <> 'interpreting'").Where("reactions.order_id = ?", order.Id).Count(&interpretedCount)
      log.Println(reactionCount)
      log.Println(interpretedCount)
      if reactionCount == interpretedCount {
        Db.Model(order).Update("status", "to_checkout")
        return
      }

      // back
      var count int
      Db.Table("samples").Joins("INNER JOIN boards ON samples.board_id = boards.id").Where("boards.status <> 'new' AND samples.order_id = ?", order.Id).Limit(1).Count(&count)
      if count == 0 {
        Db.Model(order).Update("status", "new")
      }
    case "to_checkout":
      var billOrder BillOrder
      Db.Where("order_id = ?", order.Id).First(&billOrder)
      if billOrder.BillId > 0 {
        Db.Model(order).Update("status", config.OrderStatus[3])
        return
      }
      var reactionCount int
      var interpretedCount int
      Db.Table("reactions").Where("reactions.order_id = ?", order.Id).Count(&reactionCount)
      Db.Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id").Where("reaction_files.status <> 'interpreting'").Count(&interpretedCount)
      if reactionCount > interpretedCount {
        Db.Model(order).Update("status", config.OrderStatus[1])
        return
      }
    case "checkout":
      var bill Bill
      Db.Table("bills").Joins("INNRE JOIN bill_orders ON bill_orders.bill_id = bills.id").Where("bill_orders.order_id = ? AND bills.status == 'finish'", order.Id).First(&bill)
      if bill.Status == "finish" {
        Db.Model(order).Update("status", "finish")
        return
      } else if bill.Status == "" {
        Db.Model(order).Update("status", config.OrderStatus[2])
      }

    case "finish":
      var bill Bill
      Db.Table("bills").Joins("INNRE JOIN bill_orders ON bill_orders.bill_id = bills.id").Where("bill_orders.order_id = ?", order.Id).First(&bill)
      if bill.Id > 0 {
        if bill.Status != config.BillStatus[3] && bill.Status !=config.BillStatus[4] {
          Db.Model(order).Update("status", "checkout")
          return
        }
      } else {
        Db.Model(order).Update("status", config.OrderStatus[2])
      }
  }
}
