package models
import (
  "testing"
  "strconv"
  "strings"
)

func prepareProcedures(count int) {
  Db.Exec("TRUNCATE TABLE procedures")
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("procedure` + n + `", "remark", "sample", 1, 0, 1)`)
  }
  Db.Exec("INSERT INTO procedures(name, `remark`, `flow_type`, board, attachment, creator_id) VALUES " + strings.Join(sql, ","))
}

func TestGetProcedures(t *testing.T) {
  prepareProcedures(2)
  procedures := GetProcedures()
  if len(procedures) != 2 {
    t.Errorf("procedures length error")
  }
  if procedures[1].Id != 2 {
    t.Errorf("last procedures error")
  }
}

//func TestUpdateProcedure(t *testing.T) {
//  prepareProcedures(1)
//  newProcedure := Procedure{
//    Id: 1,
//    Name: "newName",
//    Remark: "newDesc",
//    FlowType: "sample",
//    Board: true,
//    Attachment: true}
//  UpdateProcedure(newProcedure)
//  procedure := new(Procedure)
//  Db.First(procedure)
//  if procedure.Name != "newName" {
//    t.Errorf("update name error")
//  }
//}
//
//func TestProcedureValidateName (t *testing.T) {
//  p := Procedure{
//    Name: "procedure1",
//    Remark: "remark1",
//    FlowType: "sample",
//    Board: true,
//    Attachment: true}
//  var valid bool
//  //var err map[string]string
//  _, valid = p.Validate()
//  if valid != true {
//    t.Errorf("name length valid error")
//  }
//  p.Name = ""
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("name length 0 valid error")
//  }
//  p.Name = "a"
//  for i := 0; i < 101; i++ {
//    p.Name = p.Name + "a"
//  }
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("name length 100 valid error")
//  }
//}
//
//func TestProcedureValidateRemark (t *testing.T) {
//  p := Procedure{
//    Name: "procedure1",
//    Remark: "remark1",
//    FlowType: "sample",
//    Board: true,
//    Attachment: true}
//  var valid bool
//  //var err map[string]string
//  _, valid = p.Validate()
//  if valid != true {
//    t.Errorf("remark length valid error")
//  }
//  p.Remark = ""
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("remark length 0 valid error")
//  }
//  p.Remark = "a"
//  for i := 0; i < 101; i++ {
//    p.Remark = p.Remark + "a"
//  }
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("remark length 100 valid error")
//  }
//}
//
//func TestProcedureValidateFlowType (t *testing.T) {
//  p := Procedure{
//    Name: "procedure1",
//    Remark: "remark1",
//    FlowType: "sample",
//    Board: true,
//    Attachment: true}
//  var valid bool
//  //var err map[string]string
//  _, valid = p.Validate()
//  if valid != true {
//    t.Errorf("flow_type valid error")
//  }
//  p.FlowType = ""
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("flow_type valid error")
//  }
//  p.FlowType = "abcedf"
//  _, valid = p.Validate()
//  if valid == true {
//    t.Errorf("flow_type valid error")
//  }
//  p.FlowType = "reaction"
//  _, valid = p.Validate()
//  if valid != true {
//    t.Errorf("flow_type valid error")
//  }
//}
