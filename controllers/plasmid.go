package controllers

import (
  "github.com/martini-contrib/render"
  //"github.com/go-martini/martini"
  //"sequencing/models"
  "net/http"
  "encoding/json"
  "log"
)

func CreatePlasmid(req *http.Request, r render.Render) {
  var records []map[string]int
  var body []byte
  req.Body.Read(body)
  err := json.Unmarshal(body, &records)
  if err != nil {
    panic(err)
  }
  defer func(){
    if r := recover(); r != nil {
      log.Fatal(r)
    }
  }()
  log.Println(records)
}
