package models

import(
  "time"
  "strconv"
  "errors"
  "net/http"
)

type Board struct {
  Id int `json:"id"`
  BoardHeadId int `json:"board_head_id"`
  ProcedureId int `json:"procedure_id"`
  Number int `json:"number"`
  CreateDate time.Time `json:"create_date"`
  Status string `json:"status"`
  Sn string `json:"sn"`
}

func (record *Board)BeforeSave() error {
  board_head := BoardHead{}
  Db.Where("available = 1 AND id = ?", record.BoardHeadId).First(&board_head)
  if board_head.Name == "" {
    return errors.New("board_head not_exist")
  }
  // generate sn
  if board_head.WithDate {
    record.Sn = record.CreateDate.Format("20060102") + "-" + board_head.Name + strconv.Itoa(record.Number)
  } else {
    record.Sn = board_head.Name + strconv.Itoa(record.Number)
  }
  // valid repeat sn
  var exist_count int
  if record.Id > 0 {
    Db.Table("boards").Where("sn = ? AND id != ?", record.Sn, record.Id).Count(&exist_count)
  } else {
    Db.Table("boards").Where("sn = ?", record.Sn).Count(&exist_count)
  }
  if exist_count > 0 {
    return errors.New("sn repeat")
  }
  record.Sn = record.CreateDate.Format("20060102") + "-" + board_head.Name + strconv.Itoa(record.Number)
  return nil
}

func GetBoards(req *http.Request)([]map[string]interface{}, int){
  page := getPage(req)
  db := Db.Table("boards").Order("boards.id DESC").Select("boards.id, boards.sn, boards.create_date, boards.board_head_id, boards.procedure_id, boards.status, board_heads.name, board_heads.board_type").Where("board_heads.available = 1").Joins("INNER JOIN board_heads ON boards.board_head_id = board_heads.id")
  sn := req.FormValue("sn")
  if sn != "" {
    db = db.Where("boards.sn LIKE ?", sn)
  }
  board_type := req.FormValue("board_type")
  if board_type != "" {
    db = db.Where("board_heads.board_type = ?", board_type)
  }
  date_from := req.FormValue("date_from")
  if date_from != "" {
    db = db.Where("boards.create_date >= ?", date_from)
  }
  date_to := req.FormValue("date_to")
  if date_to != "" {
    db = db.Where("boards.create_date <= ?", date_to)
  }
  status := req.FormValue("status")
  if status == "unfinish" {
    db = db.Where("boards.status <> 'finish'")
  } else {
    if status != "" {
      db = db.Where("boards.status = ?", status)
    }
  }
  var count int
  db.Count(&count)
  rows, _ := db.Limit(PerPage).Offset(page * PerPage).Rows()
  var result []map[string]interface{}
  for rows.Next() {
    var id, board_head_id, procedure_id int
    var sn, status, board_head, board_type string
    var create_date time.Time
    rows.Scan(&id, &sn, &create_date, &board_head_id, &procedure_id, &status, &board_head, &board_type)
    board := Board{Id: id, BoardHeadId: board_head_id}
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "board_head_id": board_head_id,
      "procedure_id": procedure_id,
      "create_date": create_date,
      "status": status,
      "board_head": board_head,
      "board_type": board_type,
      "count": board.RecordsCount(),
    }
    result = append(result, d)
  }
  return result, count
}

// get the records, depend the type
func (board Board)Records()(interface{}) {
  if board.Id < 1 {
    return []Primer{}
  }
  board_head := BoardHead{}
  Db.Where("id = ?", board.BoardHeadId).First(&board_head)
  if board_head.BoardType == "sample" {
    records := []Sample{}
    Db.Where("board_id = ?", board.Id).Find(&records)
    return records
  }
  if board_head.BoardType == "primer" {
    records := []Primer{}
    Db.Where("board_id = ?", board.Id).Find(&records)
    return records
  } else {
    records := []Reaction{}
    Db.Where("board_id = ?", board.Id).Find(&records)
    return records
  }
}

func (board Board)RecordsCount()(int) {
  if board.Id < 1 {
    return 0
  }
  board_head := BoardHead{}
  Db.Where("id = ?", board.BoardHeadId).First(&board_head)
  var count int
  Db.Table(board_head.BoardType + "s").Where("board_id = ?", board.Id).Count(&count)
  return count
}

// when confirm, change status from new to run
// and get the first procedure to the board
func (board *Board)Confirm()(Procedure, error){
  procedure := Procedure{}
  if board.Status == "new" {
    flow := Flow{}
    Db.Where("board_head_id = ?", board.BoardHeadId).Order("flows.id").First(&flow)
    if flow.Id == 0 {
      return procedure, errors.New("flow not_exist")
    }
    procedure.Id = flow.ProcedureId
    Db.First(&procedure)
    Db.Model(board).UpdateColumns(Board{Status: "run", ProcedureId: flow.ProcedureId})
    return procedure, nil
  } else {
    return procedure, errors.New("status error")
  }
}

func (board Board)Procedures()([]Procedure) {
  procedures := []Procedure{}
  Db.Table("procedures").Joins("INNER JOIN flows ON procedures.id = flows.procedure_id").Where("flows.board_head_id = ?", board.BoardHeadId).Order("flows.id").Find(&procedures)
  return procedures
}

// check current procedure data exist
// if exist return next procedure and update procedure_id to the next
// else return the current procedure
func (board *Board)NextProcedure()(Procedure){
  if board.BoardHeadId == 0 {
    Db.First(board)
  }
  currentProcedure := Procedure{Id: board.ProcedureId}
  Db.First(&currentProcedure)
  var existCount int
  if currentProcedure.Board {
    Db.Table(currentProcedure.TableName).Where("board_id = ?", board.Id).Count(&existCount)
    if existCount == 0 {
      return currentProcedure
    }
  } else {
    // plasmids or prechecks or qualities
    procedureTable := currentProcedure.TableName
    // samples or reactions
    recordTable := currentProcedure.FlowType + "s"
    Db.Table(procedureTable).Joins("INNER JOIN samples ON " + procedureTable + "." + currentProcedure.FlowType + "_id = " + recordTable + ".id").Where(".board_id = ?", board.Id).Count(&existCount)
    var recordCount int
    Db.Table(recordTable).Where("board_id = ?", board.Id).Count(&recordCount)
    if existCount < recordCount {
      return currentProcedure
    }
  }
  flow := Flow{}
  Db.Where("board_head_id = ? AND procedure_id = ?", board.BoardHeadId, board.ProcedureId).First(&flow)
  nextFlow := Flow{}
  Db.Where("board_head_id = ? AND flow_id > ?", board.BoardHeadId, flow.Id).First(&nextFlow)
  nextProcedure := Procedure{}
  Db.Table("procedures").Joins("INNER JOIN flows ON flows.procedure_id = procedures.id").Where("flows.board_head_id = ? AND flows.id > ?", board.BoardHeadId, nextFlow.Id).First(&nextProcedure)
  if nextProcedure.Id > 0 {
    Db.Model(board).UpdateColumn("procedure_id", nextProcedure.Id)
  } else {
    Db.Model(board).UpdateColumns(Board{ProcedureId: 0, Status: "finish"})
  }
  return nextProcedure
}
