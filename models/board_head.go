package models

import(
  "net/http"
  "errors"
)

type BoardHead struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  BoardType string `json:"board_type"`
  Cols string `json:"cols"`
  Rows string `json:"rows"`
  WithDate bool `json:"with_date"`
  Available bool `json:"available"`
  IsRedo bool `json:"is_redo"`
}

// tested
func GetBoardHeads(req *http.Request)([]BoardHead, int){
  page := getPage(req)
  db := Db.Model(BoardHead{}).Order("id DESC")
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  board_type := req.FormValue("board_type")
  if board_type != "" {
    db = db.Where("board_type = ?", board_type)
  }
  isRedo := req.FormValue("is_redo")
  if isRedo != "" {
    if isRedo == "false" || isRedo == "0"{
      db = db.Where("is_redo = 0")
    } else {
      db = db.Where("is_redo = 1")
    }
  }
  available := req.FormValue("available")
  if available != "" {
    if available != "false" {
      db = db.Where("available = 1")
    } else {
      db = db.Where("available = 0")
    }
  }
  var count int
  records := []BoardHead{}
  all := req.FormValue("all")
  if all != "" {
    db.Find(&records)
  } else {
    db.Limit(PerPage).Offset(page * PerPage).Find(&records)
    db.Count(&count)
  }
  return records, count
}

// todo check the cols and rows format
// tested
func (record *BoardHead) BeforeSave()(error) {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  if len(record.Remark) > 255 {
    return errors.New("remark length error")
  }
  if record.BoardType != "sample" && record.BoardType != "primer" && record.BoardType != "reaction" {
    return errors.New("board_type error")
  }
  // check repeat name with save type
  // done by mysql unique index
  return nil
}

func (head *BoardHead)Procedures()([]Procedure) {
  procedures := []Procedure{}
  Db.Select("procedures.*").Table("procedures").Joins("INNER JOIN flows ON flows.procedure_id = procedures.id").Where("flows.board_head_id = ?", head.Id).Order("flows.id ASC").Find(&procedures)
  return procedures
}
