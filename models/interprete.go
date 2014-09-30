package models

//import(
//  "net/http"
//  "errors"
//)

type Interprete struct {
  ReactionId int `json:"reaction_id" gorm:"primary_key:yes"`
  CodeId int `json:"code_id"`
  Submit bool `json:"submit"`
  Creator
}
