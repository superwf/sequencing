package models

import(
  "net/http"
)

type Company struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Code string `json:"code"`
  ParentId int `json:"parent_id"`
  Price float64 `json:"price"`
  FullName string `json:"full_name"`
  Creator
}

func (record Company) ValidateSave()(int, interface{}) {
  if len(record.Name) > 100 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  Db.Save(&record)
  return http.StatusAccepted, record
}

func GetCompanies(req *http.Request)([]Company, int){
  page := getPage(req)
  db := Db.Model(Company{})
  name := req.FormValue("name")
  code := req.FormValue("code")
  absolute_code := req.FormValue("absolute_code")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  if code != "" {
    if absolute_code == "true" {
      db = db.Where("code = ?", code)
    } else {
      db = db.Where("code LIKE ?", (code + "%"))
    }
  }
  var count int
  db.Count(&count)
  records := []Company{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
