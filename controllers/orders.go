package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
)

func CreateOrder(params martini.Params, req *http.Request, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: id}
  parseJson(&order, req)
  //record.SetCreator(session.Get("id").(int))
  saved := models.Db.Save(&order)
  renderDbResult(r, saved, order)
}
