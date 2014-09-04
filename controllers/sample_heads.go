package controllers

import (
  "sequencing/models"
  "net/http"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  //"github.com/martini-contrib/sessions"
  "strconv"
)


func GetSampleHeads(r render.Render) {
  records := models.GetSampleHeads()
  r.JSON(http.StatusOK, records)
}

func CreateSampleHead(r render.Render, req *http.Request) {
  record := models.SampleHead{}
  parseJson(&record, req)
  r.JSON(record.ValidateSave())
}
