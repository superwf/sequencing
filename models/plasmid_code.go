package models

import(
  "errors"
  "net/http"
)

type PlasmidCode struct {
  Id int `json:"id"`
  Code string `json:"code"`
  Remark string `json:"remark"`
  Available bool `json:"available"`
  Creator
}

func (code *PlasmidCode)BeforeDelete()(error){
  plasmid := Plasmid{}
  Db.Where("plasmid_code_id = ?", code.Id).First(&plasmid)
  if plasmid.Id > 0 {
    return errors.New("plasmid already exist")
  }
  return nil
}

func GetPlasmidCodes(req *http.Request)([]PlasmidCode, int){
  page := getPage(req)
  db := Db.Model(PlasmidCode{}).Order("id DESC")
  code := req.FormValue("code")
  if code != "" {
    db = db.Where("code = ?", code)
  }
  var count int
  records := []PlasmidCode{}
  all := req.FormValue("all")
  if all == "" {
    db.Limit(PerPage).Offset(page * PerPage).Find(&records)
    db.Count(&count)
  } else {
    db.Find(&records)
  }
  return records, count
}
