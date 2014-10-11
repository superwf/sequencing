package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "net/http"
  "sequencing/models"
  //"strconv"
  "github.com/martini-contrib/sessions"
  "time"
)

func CreateBill(params martini.Params, req *http.Request, r render.Render, session sessions.Session){
  var body map[string]interface{}
  parseJson(&body, req)
  ids := body["ids"].([]interface{})
  var orderIds []int
  for _, id := range(ids){
    orderIds = append(orderIds, int(id.(float64)))
  }
  date := body["create_date"].(string)
  createDate, _ := time.Parse("2006-01-02", date)
  bill := models.CreateBill(orderIds, createDate)

  bill.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&bill)
  if saved.Error == nil {
    for _, id := range(orderIds){
      order := models.Order{Id: id}
      models.Db.First(&order)
      order.CheckStatus()
    }
  } else {
    panic(saved.Error)
  }
  renderDbResult(r, saved, bill)
}

