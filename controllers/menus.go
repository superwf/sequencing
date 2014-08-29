package controllers

import (
  //"encoding/json"
  //"log"
  "sequencing/models"
  "net/http"
  "github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
)

func Navigation(req *http.Request, r render.Render, session sessions.Session) {
  user := models.User{Id: session.Get("id").(int)}
  models.Db.First(&user)
  menus := models.Navigation(&user)
  r.JSON(http.StatusOK, menus)
}
