package models

import(
  "net/http"
  "errors"
)

type PrimerHead struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  WithDate bool `json:"with_date"`
  Available bool `json:"available"`
  Creator
}

func (record *PrimerHead) ValidateSave()(int, interface{}) {
  if len(record.Name) > 200 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  Db.Save(record)
  return http.StatusAccepted, record
}

func GetPrimerHeads(req *http.Request)([]PrimerHead, int){
  page := getPage(req)
  db := Db.Model(PrimerHead{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  records := []PrimerHead{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func (head *PrimerHead)BeforeDelete()(error){
  record := PrimerBoard{}
  Db.Model(PrimerBoard{}).Where("primer_head_id = ?", head.Id).First(&record)
  if record.Id > 0 {
    return errors.New("primer_board exist")
  }
  return nil
}
