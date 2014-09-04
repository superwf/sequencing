package models

import(
  "net/http"
)

type SampleHead struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  AutoPrecheck bool `json:"auto_precheck"`
  Available bool `json:"available"`
}

func (record *SampleHead) ValidateSave()(int, interface{}) {
  if len(record.Name) > 100 || len(record.Name) == 0 {
    return http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"}
  }
  Db.Save(record)
  return http.StatusAccepted, record
}

// should not so much procedure, so no pagination
func GetSampleHeads()([]SampleHead){
  records := []SampleHead{}
  Db.Find(&records)
  return records
}

func UpdateSampleHead(record SampleHead) {
  origin := new(Procedure)
  Db.First(origin, record.Id)
  Db.Exec("UPDATE procedures SET name = ?, remark = ?, auto_precheck = ?, available = ? WHERE id = ?", record.Name, record.Remark, record.AutoPrecheck, record.Available, record.Id)
}
