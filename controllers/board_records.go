package controllers

import(
  "net/http"
  "sequencing/models"
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "encoding/json"
)

func CreateBoardRecord(req *http.Request, r render.Render, session sessions.Session) {
  record := models.BoardRecord{}
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&record)
  if err == nil {
    now := models.Now()
    models.Db.Exec("INSERT INTO board_records(board_id, procedure_id, creator_id, data, created_at, updated_at) VALUES(?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data), updated_at = VALUES(updated_at)", record.BoardId, record.ProcedureId, session.Get("id"), record.Data, now, now)
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}
