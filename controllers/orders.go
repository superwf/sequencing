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

func Reinterprete(req *http.Request, r render.Render, session sessions.Session){
  record := map[string]int{}
  parseJson(&record, req)
  id, ok := record["id"]
  interpreterId := session.Get("id").(int)
  if ok && id > 0 {
    order := models.Order{Id: id}
    order.Reinterprete(interpreterId)
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

// show order`s reactions in bill_orderrs
func OrderReactions(params martini.Params, req *http.Request, r render.Render){
  id, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: id}
  r.JSON(http.StatusOK, order.Reactions())
}
