package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "sequencing/models"
  "sequencing/config"
  "strings"
  "net/http"
  "encoding/json"
  "strconv"
  "log"
  "time"
  //"github.com/go-martini/martini"
)

func CreatePlasmid(req *http.Request, r render.Render, session sessions.Session) {
  var records []map[string]int
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&records)
  if err != nil {
    panic(err)
  }
  defer func(){
    if r := recover(); r != nil {
      log.Fatal(r)
    }
  }()
  if len(records) > 0 {
    creatorId := strconv.Itoa(session.Get("id").(int))
    var sql []string
    var deleteIds []string
    now := time.Now().In(config.UTC).Format(time.RFC3339)
    for _, v := range records {
      if v["code_id"] > 0 {
        sql = append(sql, "(" + strconv.Itoa(v["sample_id"]) + "," + strconv.Itoa(v["code_id"]) + "," + creatorId + ",'" + now + "', '" + now + "')")
      } else {
        deleteIds = append(deleteIds, strconv.Itoa(v["sample_id"]))
      }
    }
    if len(sql) > 0 {
      models.Db.Exec("INSERT INTO plasmids(sample_id, code_id, creator_id, updated_at, created_at) VALUES" + strings.Join(sql, ",") + " ON DUPLICATE KEY UPDATE sample_id = VALUES(sample_id), code_id = VALUES(code_id), updated_at = VALUES(updated_at), created_at = VALUES(created_at)")
    }
    if len(deleteIds) > 0 {
      models.Db.Exec("DELETE FROM plasmids WHERE sample_id IN(" + strings.Join(deleteIds, ",") + ")")
    }
  }
}
