package models

import(
  "time"
  //"strconv"
  //"errors"
  //"net/http"
  //"strings"
)

type ReactionFile struct {
  Id int `json:"id"`
  ReactionId int `json:"reaction_id"`
  Files int `json:"files"`
  CreatedAt time.Time `json:"created_at"`
  UpdatedAt time.Time `json:"updated_at"`
}
