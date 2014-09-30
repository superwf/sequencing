package models

import(
  "errors"
//  "net/http"
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
  interprete := Interprete{}
  Db.Where("interpretes.code_id = ?", code.Id).First(&interprete)
  if interprete.ReactionId > 0 {
    return errors.New("interprete already exist")
  }
  return nil
}
