package models

type Procedure struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  FlowType string `json:"flow_type"`
  Board bool `json:"board"`
  Attachment bool `json:"attachment"`
  CreatorId int `json:"creator_id"`
}

func (p Procedure) Validate()(map[string]string, bool) {
  if len(p.Name) > 100 || len(p.Name) == 0 {
    return map[string]string{
      "field": "name",
      "error": "length"}, false
  }
  if len(p.Remark) > 100 || len(p.Remark) == 0 {
    return map[string]string{
      "field": "remark",
      "error": "length"}, false
  }
  return nil, true
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
  Db.Exec("UPDATE procedures SET name = ?, `remark` = ?, `flow_type` = ?, board = ?, attachment = ? WHERE id = ?", record.Name, record.Remark, record.FlowType, record.Board, record.Attachment, record.Id)
}
