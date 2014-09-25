package models

import(
  "net/http"
  "errors"
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

func (record *Vector) BeforeSave() error {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  return nil
}

func (record *Vector) BeforeDelete() error {
  sample := Sample{}
  Db.Where("vector_id = ?", record.Id).First(&sample)
  if sample.Id > 0 {
    return errors.New("sample exist")
  }
  return nil
}

func GetVectors(req *http.Request)([]Vector, int){
  page := getPage(req)
  db := Db.Model(Vector{}).Order("id DESC")
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
