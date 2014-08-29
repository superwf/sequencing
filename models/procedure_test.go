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
    sql = append(sql, `("procedure` + n + `", "desc", "sample", 1, 0, 1)`)
  }
  Db.Exec("INSERT INTO procedures(name, `desc`, `type`, board, attachment, creator_id) VALUES " + strings.Join(sql, ","))
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

func TestUpdateProcedure(t *testing.T) {
  prepareProcedures(1)
  newProcedure := Procedure{
    Id: 1,
    Name: "newName",
    Desc: "newDesc",
    Type: "sample",
    Board: 1,
    Attachment: 1}
  UpdateProcedure(newProcedure)
  procedure := new(Procedure)
  Db.First(procedure)
  if procedure.Name != "newName" {
    t.Errorf("update name error")
  }
}
