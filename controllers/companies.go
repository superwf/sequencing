package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
)
func CompanyTree(params martini.Params, req *http.Request, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  company := models.Company{Id: id}
  records := company.Children()
  result := []map[string]interface{}{}
  for _, r := range(records) {
    d := map[string]interface{}{
      "id": r.Id,
      "name": r.Name,
      "code": r.Code,
      "full_code": r.FullCode,
      "price": r.Price,
      "parent_id": r.ParentId,
      "parent": r.Parent().Name,
      "children_count": r.ChildrenCount(),
    }
    result = append(result, d)
  }
  r.JSON(http.StatusOK, result)
}
