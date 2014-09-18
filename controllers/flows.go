package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
)

func CreateFlow(params martini.Params, req *http.Request, r render.Render) {
  record := models.Flow{}
  parseJson(&record, req)
  saved := models.Db.Save(&record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": saved.Error.Error()})
  } else {
    r.JSON(http.StatusAccepted, record)
  }
}
