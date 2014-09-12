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
  Creator
}

// todo check the cols and rows format
func (record *BoardHead) BeforeSave()(error) {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  if len(record.Remark) > 255 {
    return errors.New("remark length error")
  }
  if record.BoardType != "sample" && record.BoardType != "primer" && record.BoardType != "reaction" {
    return errors.New("board_type type")
  }
  // check repeat name with save type
  exist := BoardHead{}
  Db.Where("name = ? AND board_type = ? AND id != ?", record.Name, record.BoardType, record.Id).First(&exist)
  if exist.Id > 0 {
    return errors.New("name already exist")
  }
  return nil
}

func GetBoardHeads(req *http.Request)([]BoardHead, int){
  page := getPage(req)
  db := Db.Model(BoardHead{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  board_type := req.FormValue("board_type")
  if board_type != "" {
    db = db.Where("board_type = ?", board_type)
  }
  available := req.FormValue("available")
  if available != "" {
    db = db.Where("available = ?", available)
  }
  var count int
  db.Count(&count)
  records := []BoardHead{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func (head *BoardHead)BeforeDelete()(error){
  Db.First(head)
  var count int
  Db.Table(head.BoardType + "_boards").Select("id").Where("board_head_id = ?", head.Id).Limit(1).Count(&count)
  if count > 0 {
    return errors.New("board already exist")
  }
  return nil
}
