package models

import (
  "net/http"
)

type Role struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Menus []Menu `gorm:"many2many:menus_roles"`
  Users []User
}

// tested
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

// tested
func (role Role)ActiveMenu(result map[string]interface{}) {
  if result["active"].(bool) {
    Db.Exec("INSERT INTO menus_roles(role_id, menu_id) VALUES(?, ?)", role.Id, result["menu_id"])
  } else {
    Db.Exec("DELETE FROM menus_roles WHERE role_id = ? AND menu_id = ?", role.Id, result["menu_id"])
  }
}
