package models

import(
  "net/http"
)

type Vector struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Producer string `json:"remark"`
  Length string `json:"length"`
  Resistance string `json:"resistance"`
  CopyNumber string `json:"copy_number"`
  Creator
}

func (record *Vector) ValidateSave()(int, interface{}) {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  Db.Save(record)
  return http.StatusAccepted, record
}

func GetVectors(req *http.Request)([]Vector, int){
  page := getPage(req)
  db := Db.Model(Vector{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  records := []Vector{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
