package models

import(
  "net/http"
  "time"
)

type PrimerBoard struct {
  Id int `json:"id"`
  Sn string `json:"sn"`
  Remark string `json:"remark"`
  CreatedDate time.Time `json:"created_date"`
  Number int `json:"number"`
  PrimerHeadId int `json:"primer_head_id"`
  Creator
}

func (record *PrimerBoard) ValidateSave()(int, interface{}) {
  head := PrimerHead{Id: record.PrimerHeadId}
  Db.First(&head)
  if head.Name == "" {
    return http.StatusNotAcceptable, map[string]string{
      "field": "primer_head",
      "error": "needed"}
  }
  Db.Save(record)
  return http.StatusAccepted, record
}

func GetPrimerBoards(req *http.Request)([]PrimerBoard, int){
  page := getPage(req)
  db := Db.Model(PrimerBoard{})
  sn := req.FormValue("sn")
  if sn != "" {
    db = db.Where("sn = ?", sn)
  }
  var count int
  db.Count(&count)
  records := []PrimerBoard{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}
