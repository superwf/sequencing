package models

import(
  "net/http"
  "errors"
)

type Procedure struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  FlowType string `json:"flow_type"`
  Board bool `json:"board"`
  Attachment bool `json:"attachment"`
  Creator
}

func (p *Procedure) BeforeSave() error {
  if len(p.Name) > 255 || len(p.Name) == 0 {
    return errors.New("name length error")
  }
  if len(p.Remark) > 255 {
    return errors.New("remark length error")
  }
  if p.FlowType != "sample" && p.FlowType != "reaction" {
    return errors.New("flow_type type error")
  }
  return nil
}

func GetProcedures(req *http.Request)([]Procedure, int){
  page := getPage(req)
  db := Db.Model(Procedure{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  records := []Procedure{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
