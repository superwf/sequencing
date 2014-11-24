package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
  "strconv"
)

func BoardHeadProcedures(params martini.Params, r render.Render){
  id, _ := strconv.Atoi(params["id"])
  head := models.BoardHead{Id: id}
  r.JSON(http.StatusOK, head.Procedures())
}
