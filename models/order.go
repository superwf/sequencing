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

// client_id is forigin key restrict
// tested
func (record *Order)BeforeCreate() error {
  board_head := BoardHead{}
  Db.Where("available = 1 AND id = ?", record.BoardHeadId).First(&board_head)
  if board_head.Name == "" {
    return errors.New("board_head not_exist")
  }
  if record.Sn == "" {
    record.Sn = record.CreateDate.Format("20060102") + "-" + board_head.Name + strconv.Itoa(record.Number)
  }
  record.Status = config.OrderStatus[0]
  return nil
}

// tested
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

// generate sn
func (order *Order)GenerateReworkSn(parentOrder *Order){
  board_head := BoardHead{}
  Db.Where("id = ?", order.BoardHeadId).First(&board_head)
  if board_head.Name != "" && parentOrder.Sn != "" {
    order.Sn = parentOrder.Sn + "-" + board_head.Name + order.CreateDate.Format("0102")
  } else {
    order.Sn = ""
  }
}

// generate rework order by interprete_code
func (order *Order)GenerateReworkOrder() {
  rows, _ := Db.Table("reaction_files").Select("reactions.id, samples.id, interprete_codes.board_head_id").Joins("INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN samples ON reactions.sample_id = samples.id").Where("reactions.order_id = ? AND interprete_codes.board_head_id > 0", order.Id).Rows()
  for rows.Next() {
    var reactionId, sampleId, boardHeadId int
    rows.Scan(&reactionId, &sampleId, &boardHeadId)
    newOrder := Order{BoardHeadId: boardHeadId, CreateDate: time.Now()}
    newOrder.GenerateReworkSn(order)
    Db.Save(&newOrder)
    sample := Sample{}
    Db.Where("parent_id = ?", sampleId).First(&sample)
    // if no child sample in the new order
    if sample.Id == 0 {
      sample := Sample{Id: sampleId}
      Db.First(&sample)
      sample.Id = 0
      sample.OrderId = newOrder.Id
      sample.BoardId = 0
      sample.Hole = ""
      sample.ParentId = sampleId
      Db.Save(&sample)

      reaction := Reaction{Id: reactionId}
      Db.First(&reaction)
      reaction.Id = 0
      reaction.OrderId = newOrder.Id
      reaction.BoardId = 0
      reaction.Hole = ""
      reaction.DilutePrimerId = 0
      reaction.SampleId = sample.Id
      reaction.ParentId = reactionId
      Db.Save(&reaction)
    } else {
      reaction := Reaction{}
      Db.Where("parent_id = ?", reactionId).First(&reaction)
      if reaction.Id == 0 {
        reaction := Reaction{Id: reactionId}
        Db.First(&reaction)
        reaction.Id = 0
        reaction.OrderId = newOrder.Id
        reaction.SampleId = sample.Id
        reaction.BoardId = 0
        reaction.Hole = ""
        reaction.DilutePrimerId = 0
        reaction.ParentId = reactionId
        Db.Save(&reaction)
      }
    }
  }
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
  Db.Exec("UPDATE samples, reactions SET reactions.order_id = samples.order_id WHERE samples.order_id = ? AND samples.id = reactions.sample_id", order.Id)
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
  Db.Exec("UPDATE reaction_files, reactions SET reaction_files.status = 'sent' WHERE reactions.order_id = ? AND reactions.id = reaction_files.reaction_id AND reaction_files.status = 'interpreted'", order.Id)
  Db.First(order)
  order.GenerateReworkOrder()
}

func (order *Order)Reinterprete(interpreterId int){
  Db.Exec("UPDATE reaction_files, reactions SET reaction_files.status = 'interpreting', reaction_files.interpreter_id = ? WHERE reactions.order_id = ? AND reactions.id = reaction_files.reaction_id AND reaction_files.status = 'interpreted'", interpreterId, order.Id)
}

func (order *Order)Reactions()([]map[string]interface{}){
  db := Db.Select("samples.name, boards.sn, primers.name, reaction_files.code_id, reactions.remark").Table("reactions").Joins("INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN primers ON reactions.primer_id = primers.id LEFT JOIN boards ON samples.board_id = boards.id LEFT JOIN reaction_files ON reactions.id = reaction_files.reaction_id").Where("reactions.order_id = ?", order.Id)
  rows, _ := db.Rows()
  result := []map[string]interface{}{}
  for rows.Next() {
    var sample, board, primer, remark string
    var codeId int
    rows.Scan(&sample, &board, &primer, &codeId, &remark)
    result = append(result, map[string]interface{}{
      "sample": sample,
      "board": board,
      "primer": primer,
      "code_id": codeId,
      "remark": remark,
    })
  }
  return result
}

func ReceiveOrder(){
}

func NewOrder(clientId, boardHeadId int, parentOrder *Order)Order{
  var maxNumber int
  Db.Select("MAX(number)").Table("orders").Where("create_date = ? AND board_head_id = ?", Today(), boardHeadId).Row().Scan(&maxNumber)
  order := Order{CreateDate: time.Now(), Number: maxNumber + 1, ClientId: clientId, BoardHeadId: boardHeadId}
  if parentOrder.Sn != "" {
    o := &order
    o.GenerateReworkSn(parentOrder)
  }
  return order
}

// should only be run in a loop go routine
func CheckOrderStatus(){
  for {
    // for new order
    newOrderCount := 0
    Db.Table("orders").Joins("INNER JOIN samples ON orders.id = samples.order_id INNER JOIN boards ON samples.board_id = boards.id").Where("orders.status = ? AND boards.status <> ?", config.OrderStatus[0], config.BoardStatus[0]).Count(&newOrderCount)
    if(newOrderCount > 0) {
      Db.Exec("UPDATE orders INNER JOIN samples ON orders.id = samples.order_id INNER JOIN boards ON samples.board_id = boards.id SET orders.status = ? WHERE orders.status = ? AND boards.status <> ?", config.OrderStatus[1], config.OrderStatus[0], config.BoardStatus[0])
    }
    // todo for run order
    runOrders := make([]Order, 0)
    Db.Table("orders").Where("status = ?", config.OrderStatus[1]).Find(&runOrders)
    if(len(runOrders) > 0) {
      for _, o := range(runOrders) {
        notPrecheckedSampleCount := 0
        Db.Table("samples").Joins("LEFT JOIN prechecks ON samples.id = prechecks.sample_id").Where("prechecks.sample_id = NULL").Count(&notPrecheckedSampleCount)
        if(notPrecheckedSampleCount > 0) {
          continue
        }
        // now all samples are prehcecked
        // check if all those can be interpreted reactions are interpreted
        canInterpretedCount := 0
        Db.Table("reactions").Joins("INNER JOIN prechecks ON prechecks.sample_id = reactions.sample_id INNER JOIN precheck_codes ON prechecks.code_id = precheck_codes.id").Where("reactions.order_id = ? AND precheck_codes.ok = 1", o.Id).Count(&canInterpretedCount)
        interpretedCount := 0
        Db.Table("reactions").Joins("INNER JOIN prechecks ON prechecks.sample_id = reactions.sample_id INNER JOIN precheck_codes ON prechecks.code_id = precheck_codes.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id").Where("reactions.order_id = ? AND precheck_codes.ok = 1 AND reaction_files.code_id <> 0", o.Id)
        if(canInterpretedCount > interpretedCount) {
          continue
        } else {
          Db.Exec("UPDATE orders SET status = ? WHERE orders.id = ?", config.OrderStatus[2], o.Id)
        }
      }
    }
    // bill can operate order status in bill AfterCreate and AfterSave hooks, not here
    time.Sleep(time.Minute * 10)
  }
}
