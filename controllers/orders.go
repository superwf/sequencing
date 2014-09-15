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
  records := models.order(id)
  var result []map[string]interface{}
  for _, r := range(records) {
    d := map[string]interface{}{
      "id": r.Id,
      "sn": r.Sn,
    }
    result = append(result, d)
  }
  r.JSON(http.StatusOK, result)
}
