package models

import(
  "time"
  //"strconv"
  //"errors"
  //"net/http"
  //"strings"
)

type ReactionFile struct {
  ReactionId int `json:"reaction_id" gorm:"primary_key:yes"`
  CreatedAt time.Time `json:"created_at"`
  UpdatedAt time.Time `json:"updated_at"`
}
