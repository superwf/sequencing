package controllers

import (
  "github.com/martini-contrib/render"
  "sequencing/models"
  "net/http"
  "github.com/martini-contrib/sessions"
)

func SendingOrderMails(r render.Render){
  r.JSON(http.StatusOK, models.SendingOrderMails())
}

// todo generate rework order
func CreateOrderMail(req *http.Request, r render.Render, session sessions.Session){
  record := models.OrderMail{}
  parseJson(&record, req)
  record.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": saved.Error.Error()})
  } else {
    order := models.Order{Id: record.OrderId}
    order.SubmitInterpretedReactionFiles()
    r.JSON(http.StatusOK, record)
  }
}

func SubmitInterpretedReactionFiles(req *http.Request, r render.Render){
  record := map[string]int{}
  parseJson(&record, req)
  orderId, ok := record["order_id"]
  if ok && orderId > 0 {
    order := models.Order{Id: orderId}
    order.SubmitInterpretedReactionFiles()
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

func Reinterprete(req *http.Request, r render.Render){
  record := map[string]int{}
  parseJson(&record, req)
  orderId, ok := record["order_id"]
  if ok && orderId > 0 {
    order := models.Order{Id: orderId}
    order.Reinterprete()
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}
