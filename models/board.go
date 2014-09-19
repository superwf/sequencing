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
  db := Db.Table("boards").Order("boards.id DESC").Select("boards.id, boards.sn, boards.create_date, boards.board_head_id, boards.status, board_heads.name, board_heads.board_type").Where("board_heads.available = 1").Joins("INNER JOIN board_heads ON boards.board_head_id = board_heads.id")
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
    var id, board_head_id int
    var sn, status, board_head, board_type string
    var create_date time.Time
    rows.Scan(&id, &sn, &create_date, &board_head_id, &status, &board_head, &board_type)
    board := Board{Id: id, BoardHeadId: board_head_id}
    d := map[string]interface{}{
      "id": id,
      "sn": sn,
      "board_head_id": board_head_id,
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
func (board *Board)Confirm() error{
  if board.Status == "new" {
    flow := Flow{}
    Db.WHere("board_head_id = ?", board.BoardHeadId).Order("flows.id").First(&flow)
    Db.Model(board).UpdateColumns(Board{Status: "run", ProcedureId: flow.ProcedureId})
    return nil
  } else {
    return errors.New("status error")
  }
}

func (board Board)Procedures()([]Procedure) {
  procedures := []Procedure{}
  Db.Table("procedures").Joins("INNER JOIN flows ON procedures.id = flows.procedure_id").Where("flows.board_head_id = ?", board.BoardHeadId).Order("flows.id").Find(&procedures)
  return procedures
}

func (board Board)NextProcedure()(Procedure) {
  procedure := Procedure{}
  Db.Table("procedures").Joins("INNER JOIN flows ON procedures.id = flows.procedure_id").Where("flows.board_head_id = ? AND flows.board_head_id > ?", board.ProcedureId, board.BoardHeadId).Order("flows.id").First(&procedures)
  return procedure
}
