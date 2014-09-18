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

func GetBoards(req *http.Request)([]Board, int){
  page := getPage(req)
  db := Db.Model(Board{}).Order("boards.id DESC")
  sn := req.FormValue("sn")
  if sn != "" {
    db = db.Where("sn LIKE ?", sn)
  }
  board_type := req.FormValue("board_type")
  if board_type != "" {
    db = db.Joins("INNER JOIN board_heads ON boards.board_head_id = board_heads.id").Where("board_heads.board_type = ?", board_type)
  }
  var count int
  db.Count(&count)
  records := []Board{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
