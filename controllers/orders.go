package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
)

func CreateOrder(params martini.Params, req *http.Request, r render.Render, session sessions.Session) {
  id, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: id}
  parseJson(&order, req)
  order.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&order)
  if saved.Error == nil {
    order.RelateReactions()
  }
  renderDbResult(r, saved, order)
}
