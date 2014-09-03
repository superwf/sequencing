package models

import(
  "github.com/martini-contrib/render"
  "net/http"
)

type SampleHead struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Remark string `json:"remark"`
  AutoPrecheck bool `json:"board"`
  Available bool `json:"attachment"`
}

func (record SampleHead) ValidateSaveRender(r render.Render) {
  if len(record.Name) > 100 || len(record.Name) == 0 {
    r.JSON(http.StatusNotAcceptable, map[string]string{
      "field": "name",
      "error": "length"})
  }
  if len(record.Remark) > 100 || len(record.Remark) == 0 {
    r.JSON(http.StatusNotAcceptable, map[string]string{
      "field": "remark",
      "error": "length"})
  }
  Db.Save(&record)
  r.JSON(http.StatusAccepted, record)
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
