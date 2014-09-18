package models

type Flow struct {
  Id int `json:"id"`
  ProcedureId int `json:"procedure_id"`
  BoardHeadId int `json:"board_head_id"`
}
