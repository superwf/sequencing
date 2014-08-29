package models


type Procedure struct {
  Id int `json:"id"`
  Name string `json:"name" binding:"required"`
  Desc string `json:"desc"`
  Type string `json:"type"`
  Board bool `json:"board"`
  Attachment bool `json:"attachment"`
  CreatorId int `json:"creator_id"`
}

// should not so much procedure, so no pagination
func GetProcedures()([]Procedure){
  procedures := []Procedure{}
  Db.Find(&procedures)
  return procedures
}

func UpdateProcedure(record Procedure) {
  origin := new(Procedure)
  Db.First(origin, record.Id)
  Db.Exec("UPDATE procedures SET name = ?, `desc` = ?, `type` = ?, board = ?, attachment = ? WHERE id = ?", record.Name, record.Desc, record.Type, record.Board, record.Attachment, record.Id)
}
