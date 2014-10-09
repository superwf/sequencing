package models

import(
  "errors"
  "net/http"
)

type InterpreteCode struct {
  Id int `json:"id"`
  Code string `json:"code"`
  Result string `json:"result"`
  Charge bool `json:"charge"`
  Available bool `json:"available"`
  Remark string `json:"remark"`
  Creator
}

func (code *InterpreteCode)BeforeDelete()(error){
  reactionFile := ReactionFile{}
  Db.Where("reactino_files.code_id = ?", code.Id).First(&reactionFile)
  if reactionFile.ReactionId > 0 {
    return errors.New("reaction_file already exist")
  }
  return nil
}

func GetInterpreteCodes(req *http.Request)([]InterpreteCode, int){
  page := getPage(req)
  db := Db.Model(InterpreteCode{}).Order("id DESC")
  code := req.FormValue("code")
  if code != "" {
    db = db.Where("code = ?", code)
  }
  available := req.FormValue("available")
  if available != "" {
    db = db.Where("available = ?", available)
  }
  var count int
  records := []InterpreteCode{}
  all := req.FormValue("all")
  if all == "" {
    db.Limit(PerPage).Offset(page * PerPage).Find(&records)
    db.Count(&count)
  } else {
    db.Find(&records)
  }
  return records, count
}
