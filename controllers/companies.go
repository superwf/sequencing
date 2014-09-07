package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
)
func GetCompanyTree(params martini.Params, req *http.Request, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  records := models.GetCompanyTree(id)
  var result []map[string]interface{}
  for _, r := range(records) {
    d := map[string]interface{}{
      "id": r.Id,
      "name": r.Name,
      "code": r.Code,
      "price": r.Price,
      "children_count": r.GetChildrenCount(),
    }
    result = append(result, d)
  }
  r.JSON(http.StatusOK, result)
}
