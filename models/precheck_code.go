package models

import(
  "errors"
  "net/http"
)

type PrecheckCode struct {
  Id int `json:"id"`
  Code string `json:"code"`
  Ok bool `json:"ok"`
  Available bool `json:"available"`
  Remark string `json:"remark"`
  Creator
}

func (code *PrecheckCode)BeforeDelete()(error){
  precheck := Precheck{}
  Db.Where("precheck = ?", code.Id).First(&precheck)
  if precheck.Id > 0 {
    return errors.New("precheck already exist")
  }
  return nil
}

func GetPrecheckCodes(req *http.Request)([]PrecheckCode, int){
  page := getPage(req)
  db := Db.Model(PrecheckCode{}).Order("id DESC")
  code := req.FormValue("code")
  if code != "" {
    db = db.Where("code = ?", code)
  }
  var count int
  records := []PrecheckCode{}
  all := req.FormValue("all")
  if all == "" {
    db.Limit(PerPage).Offset(page * PerPage).Find(&records)
    db.Count(&count)
  } else {
    db.Find(&records)
  }
  return records, count
}
