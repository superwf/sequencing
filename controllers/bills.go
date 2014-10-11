package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "net/http"
  "sequencing/models"
  "strconv"
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
  bill := models.GenerateBillSn(orderIds, createDate)

  bill.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&bill)
  if saved.Error == nil {
    for _, id := range orderIds {
      var count int
      models.Db.Table("reaction_files").Joins("INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id").Where("reactions.order_id = ? AND interprete_codes.charge = 1 ", id).Count(&count)
      billOrder := models.BillOrder{
        OrderId: id,
        BillId: bill.Id,
        ChargeCount: count,
      }
      s := models.Db.FirstOrCreate(&billOrder)
      if s.Error == nil {
        order := models.Order{Id: id}
        order.CheckStatus()
      }
    }
  } else {
    panic(saved.Error)
  }
  renderDbResult(r, saved, bill)
}

func DeleteBill(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  b := models.Bill{Id: id}
  orders := []models.Order{}
  models.Db.Joins("INNER JOIN bill_orders ON bill_orders.order_id = orders.id").Where("bill_orders.bill_id = ?", params["id"]).Find(&orders)
  d := models.Db.Delete(&b)
  if d.Error == nil {
    for _, o := range orders {
      o.CheckStatus()
    }
  }
}
