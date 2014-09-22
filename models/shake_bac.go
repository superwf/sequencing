package models

import(
  "errors"
)

type ShakeBac struct {
  Id int `json:"id"`
  BoardId int `json:"board_id"`
  Remark string `json:"remark"`
  Creator
}

func (record *ShakeBac) BeforeSave() error {
  board := Board{Id: record.BoardId}
  Db.First(&board)
  if board.Sn == "" {
    return errors.New("board not_exist")
  }
  return nil
}
