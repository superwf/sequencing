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
  reactionFile := ReactionFile{}
  Db.Where("reactino_files.code_id = ?", code.Id).First(&reactionFile)
  if reactionFile.ReactionId > 0 {
    return errors.New("reaction_file already exist")
  }
  return nil
}
