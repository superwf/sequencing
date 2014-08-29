package controllers

import (
  "sequencing/models"
  //"github.com/go-martini/martini"
  "net/http"
  "github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
  //"strconv"
)

func GetUsers(req *http.Request, r render.Render) {
  users, count := models.GetUsers(req)
  result := map[string]interface{}{
    "records": users,
    "totalItems": count,
    "perPage": models.PerPage}
  r.JSON(http.StatusOK, result)
}

func Me(session sessions.Session, r render.Render) {
  if session.Get("name") != nil {
    //r.JSON(http.StatusUnauthorized, Ok_false)
  //} else {
    user := models.User{Id: session.Get("id").(int)}
    models.Db.First(&user)
    r.JSON(http.StatusOK, map[string]interface{}{
      "id": session.Get("id"),
      "name": session.Get("name"),
      "email": session.Get("email"),
      "menus": models.Navigation(&user)})
  }
}

func Login(req *http.Request, session sessions.Session, r render.Render) {
  user := models.User{}
  parseJson(&user, req)
  http_status, user_map := models.Login(&user)
  id, ok := user_map["id"]
  if ok || id.(int) > 0 {
    user_map["menus"] = models.Navigation(&user)
    session.Set("id", user_map["id"])
    session.Set("name", user_map["name"])
    session.Set("email", user_map["email"])
  }
  r.JSON(http_status, user_map)
}

func Logout(session sessions.Session, r render.Render) {
  session.Clear()
  r.JSON(http.StatusOK, Ok_true)
}
