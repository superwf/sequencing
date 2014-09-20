package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
  "strconv"
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

func DeleteFlow(params martini.Params, r render.Render){
  id, _ := strconv.Atoi(params["id"])
  record := models.Flow{Id: id}
  deleted := models.Db.Delete(&record)
  if deleted.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": deleted.Error.Error()})
  } else {
    r.JSON(http.StatusOK, record)
  }
}
