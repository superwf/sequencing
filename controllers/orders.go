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
  record := models.Order{Id: id}
  parseJson(&record, req)
  //record.SetCreator(session.Get("id").(int))
  saved := models.Db.Save(&record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": saved.Error.Error()})
  } else {
    r.JSON(http.StatusOK, record)
  }
}
