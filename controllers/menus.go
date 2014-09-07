package controllers

import (
  //"encoding/json"
  //"log"
  "sequencing/models"
  "net/http"
  //"github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
)

//func Navigation(req *http.Request, r render.Render, session sessions.Session) {
//  user := models.User{Id: session.Get("id").(int)}
//  models.Db.First(&user)
//  menus := models.Navigation(&user)
//  r.JSON(http.StatusOK, menus)
//}

func GetMenus(r render.Render) {
  var records []map[string]interface{}
  rows, _ := models.Db.Table("menus").Select("id, name, parent_id, url, menus_roles.role_id").Joins("LEFT JOIN menus_roles ON menus.id = menus_roles.menu_id").Rows()
  for rows.Next() {
    var name, url string
    var id, parent_id, active int
    rows.Scan(&id, &name, &parent_id, &url, &active)
    records = append(records, map[string]interface{}{
      "id": id,
      "name": name,
      "parent_id": parent_id,
      "url": url,
      "active": active})
  }
  r.JSON(http.StatusOK, records)
}
