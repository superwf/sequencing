package models

import(
  "net/http"
  "errors"
)

type SampleHead struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  AutoPrecheck bool `json:"auto_precheck"`
  Available bool `json:"available"`
  Creator
}

func (record *SampleHead) BeforeSave() error {
  if len(record.Name) > 255 || len(record.Name) == 0 {
    return errors.New("name length error")
  }
  return nil
}

func GetSampleHeads(req *http.Request)([]SampleHead, int){
  page := getPage(req)
  db := Db.Model(SampleHead{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  var count int
  db.Count(&count)
  records := []SampleHead{}
  db.Limit(PerPage).Offset(page * PerPage).Find(&records)
  return records, count
}

func UpdateSampleHead(record SampleHead) {
  origin := new(Procedure)
  Db.First(origin, record.Id)
  Db.Exec("UPDATE procedures SET name = ?, remark = ?, auto_precheck = ?, available = ? WHERE id = ?", record.Name, record.Remark, record.AutoPrecheck, record.Available, record.Id)
}
