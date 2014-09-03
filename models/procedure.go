package models

import(
  "github.com/martini-contrib/render"
  "net/http"
)

type Procedure struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  FlowType string `json:"flow_type"`
  Board bool `json:"board"`
  Attachment bool `json:"attachment"`
  CreatorId int `json:"creator_id"`
}

func (p Procedure) ValidateSaveRender(r render.Render) {
  if len(p.Name) > 100 || len(p.Name) == 0 {
    r.JSON(http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"})
  }
  if len(p.Remark) > 100 || len(p.Remark) == 0 {
    r.JSON(http.StatusNotAcceptable, map[string]string{
      "field": "remark",
      "error": "length"})
  }
  if p.FlowType != "sample" && p.FlowType != "reaction" {
    r.JSON(http.StatusNotAcceptable, map[string]string{
      "field": "flow_type",
      "error": "select"})
  }
  Db.Save(&p)
  r.JSON(http.StatusAccepted, p)
}

// should not so much procedure, so no pagination
func GetProcedures()([]Procedure){
  procedures := []Procedure{}
  Db.Find(&procedures)
  return procedures
}

//func UpdateProcedure(record Procedure) {
//  origin := new(Procedure)
//  Db.First(origin, record.Id)
//  Db.Exec("UPDATE procedures SET name = ?, `remark` = ?, `flow_type` = ?, board = ?, attachment = ? WHERE id = ?", record.Name, record.Remark, record.FlowType, record.Board, record.Attachment, record.Id)
//}
