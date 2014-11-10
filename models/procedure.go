package models

import(
  "net/http"
  "errors"
)

type Procedure struct {
  Id int `json:"id"`
  Name string `json:"name"`
  RecordName string `json:"record_name"`
  Remark string `json:"remark"`
  FlowType string `json:"flow_type"`
  Board bool `json:"board"`
}

// tested
func GetProcedures(req *http.Request)([]Procedure, int){
  db := Db.Model(Procedure{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  flow_type := req.FormValue("flow_type")
  if flow_type != "" {
    db = db.Where("flow_type = ?", flow_type)
  }
  recordName := req.FormValue("record_name")
  if recordName != "" {
    db = db.Where("record_name = ?", recordName)
  }
  board_head_id := req.FormValue("board_head_id")
  if board_head_id != "" {
    db = db.Joins("INNER JOIN flows ON flows.procedure_id = procedures.id").Where("flows.board_head_id = ?", board_head_id).Order("flows.id")
  }
  var count int
  records := []Procedure{}
  all := req.FormValue("all")
  if all != "" {
    db.Find(&records)
  } else {
    page := getPage(req)
    db.Count(&count)
    db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  }
  return records, count
}

// tested
func (p *Procedure) BeforeSave() error {
  if len(p.Name) > 255 || len(p.Name) == 0 {
    return errors.New("name length error")
  }
  if len(p.RecordName) > 255 || len(p.RecordName) == 0 {
    return errors.New("table length error")
  }
  if len(p.Remark) > 255 {
    return errors.New("remark length error")
  }
  if p.FlowType != "sample" && p.FlowType != "reaction" {
    return errors.New("flow_type type error")
  }
  return nil
}

// flow procedure_id is foreign key restrict, so only check board procedure_id
func (p *Procedure)BeforeDelete() error {
  count := 0
  Db.Table("boards").Where("procedure_id = ?", p.Id).Count(&count)
  if count > 0 {
    return errors.New("already relate board")
  }
  return nil
}
