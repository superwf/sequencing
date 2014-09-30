package models

import(
  "net/http"
  //"errors"
)

type Reaction struct {
  Id int `json:"id"`
  SampleId int `json:"sample_id"`
  PrimerId int `json:"primer_id"`
  DilutePrimerId int `json:"dilute_primer_id"`
  BoardId int `json:"board_id"`
  Hole string `json:"hole"`
  Remark string `json:"remark"`
}

func GetReactions(req *http.Request)([]Reaction, int){
  page := getPage(req)
  db := Db.Model(Reaction{})
  sample_id := req.FormValue("sample_id")
  if sample_id != "" {
    db = db.Where("sample_id = ?", sample_id)
  }
  var count int
  db.Count(&count)
  records := []Reaction{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

//func (record *Reaction) BeforeSave() error {
//  sample := Sample{Id: record.SampleId}
//  Db.First(&sample)
//  nameLength := len(sample.Name)
//  if nameLength == 0{
//    return errors.New("sample not_exist")
//  }
//  return nil
//}
