package models

import (
  "net/http"
)

type Role struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Menus []Menu `gorm:"many2many:menus_roles"`
  Users []User
  Creator
}

func (r Role)ValidateSave()(int, interface{}){
  return 0, nil
}

func GetRoles(req *http.Request)([]Role, int){
  page := getPage(req)
  db := Db.Model(Role{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", ("%" + name + "%"))
  }
  var count int
  db.Count(&count)
  records := []Role{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func RoleActiveMenu(result map[string]interface{}, role_id int) {
  if result["active"].(bool) {
    Db.Exec("INSERT INTO menus_roles(role_id, menu_id) VALUES(?, ?)", role_id, result["menu_id"])
  } else {
    Db.Exec("DELETE FROM menus_roles WHERE role_id = ? AND menu_id = ?", role_id, result["menu_id"])
  }
}
