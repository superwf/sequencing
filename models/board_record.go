package models

import(
  "errors"
)

type BoardRecord struct {
  Id int `json:"id"`
  BoardId int `json:"board_id"`
  Data string `json:"data"`
  ProcedureId int `json:"procedure_id"`
  Creator
}

func (record *BoardRecord) BeforeSave() error {
  board := Board{Id: record.BoardId}
  Db.First(&board)
  if board.Sn == "" {
    return errors.New("board not_exist")
  }
  return nil
}
