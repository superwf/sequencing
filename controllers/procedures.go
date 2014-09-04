package controllers

import (
  "sequencing/models"
  "net/http"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "github.com/martini-contrib/sessions"
  "strconv"
)


func GetProcedures(r render.Render) {
  records := models.GetProcedures()
  r.JSON(http.StatusOK, records)
}

func GetProcedure(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  record := models.Procedure{Id: id}
  models.Db.First(&record)
  r.JSON(http.StatusOK, record)
}

func CreateProcedure(r render.Render, req *http.Request, session sessions.Session) {
  record := models.Procedure{}
  parseJson(&record, req)
  record.CreatorId = session.Get("id").(int)
  r.JSON(record.ValidateSave())
}

func UpdateProcedure(params martini.Params, r render.Render, req *http.Request) {
  record := models.Procedure{}
  parseJson(&record, req)
  id, _ := strconv.Atoi(params["id"])
  record.Id = id
  r.JSON(record.ValidateSave())
}

func DeleteProcedure(params martini.Params, r render.Render, req *http.Request) {
  record := models.Procedure{}
  id, _ := strconv.Atoi(params["id"])
  record.Id = id
  models.Db.Delete(&record)
  r.JSON(http.StatusOK, record)
}
