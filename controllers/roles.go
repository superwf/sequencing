package controllers

import (
  //"encoding/json"
  //"log"
  "strconv"
  "sequencing/models"
  "net/http"
  //"github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
)

func UpdateRole(params martini.Params, r render.Render, req *http.Request){
  id, _ := strconv.Atoi(params["id"])
  var result map[string]interface{}
  parseJson(&result, req)
  models.RoleActiveMenu(result, id)
  r.JSON(http.StatusAccepted, Ok_true)
}
