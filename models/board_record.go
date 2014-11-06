package models

import(
  "net/http"
)
type BoardRecord struct {
  Id int `json:"id"`
  BoardId int `json:"board_id"`
  Data string `json:"data"`
  ProcedureId int `json:"procedure_id"`
  Creator
}

// validate by database foreign key constraint
//func (record *BoardRecord) BeforeSave() error {
//  board := Board{Id: record.BoardId}
//  Db.First(&board)
//  if board.Sn == "" {
//    return errors.New("board not_exist")
//  }
//  return nil
//}

func GetBoardRecords(req *http.Request)([]BoardRecord, int){
  page := getPage(req)
  db := Db.Model(BoardRecord{}).Order("id DESC")
  boardId := req.FormValue("board_id")
  if boardId != "" {
    db = db.Where("board_id = ?", boardId)
  }
  procedureId := req.FormValue("procedure_id")
  if procedureId != "" {
    db = db.Where("procedure_id = ?", procedureId)
  }
  var count int
  db.Count(&count)
  records := []BoardRecord{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
