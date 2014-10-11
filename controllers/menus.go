package controllers

import (
  //"encoding/json"
  //"log"
  //"github.com/martini-contrib/sessions"
  "sequencing/models"
  "net/http"
  "github.com/martini-contrib/render"
  "strconv"
)

//func Navigation(req *http.Request, r render.Render, session sessions.Session) {
//  user := models.User{Id: session.Get("id").(int)}
//  models.Db.First(&user)
//  menus := models.Navigation(&user)
//  r.JSON(http.StatusOK, menus)
//}

func GetMenus(req *http.Request, r render.Render) {
  id := req.FormValue("role_id")
  roleId, _ := strconv.Atoi(id)
  records := []map[string]interface{}{}
  rows, _ := models.Db.Table("menus").Select("menus.id, menus.name, menus.parent_id, menus.url, menus_roles.role_id").Joins("LEFT JOIN menus_roles ON menus.id = menus_roles.menu_id").Rows()
  for rows.Next() {
    var name, url string
    var id, parent_id, active int
    rows.Scan(&id, &name, &parent_id, &url, &active)
    records = append(records, map[string]interface{}{
      "id": id,
      "name": name,
      "parent_id": parent_id,
      "url": url,
      "active": active == roleId,
    })
  }
  r.JSON(http.StatusOK, records)
}
