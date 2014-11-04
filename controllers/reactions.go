package controllers

import (
  "github.com/martini-contrib/render"
  "encoding/json"
  "sequencing/models"
  "net/http"
)

func TypesetReactionSampleBoards(req *http.Request, r render.Render) {
  sampleBoards := models.TypesetingReactionSampleBoards()
  r.JSON(http.StatusOK, sampleBoards)
}

func TypesetReactions(req *http.Request, r render.Render){
  var reactions []models.Reaction
  parseJson(&reactions, req)
  for _, reaction := range(reactions) {
    models.Db.Exec("UPDATE reactions SET board_id = ?, hole = ? WHERE id = ?", reaction.BoardId, reaction.Hole, reaction.Id)
  }
  r.JSON(http.StatusOK, Ok_true)
}

func ReworkingReactions(req *http.Request, r render.Render){
  r.JSON(http.StatusOK, models.ReworkingReactions(req))
}

func UpdateReaction(req *http.Request, r render.Render){
  d := map[string]interface{}{}
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&d)
  if err == nil {
    sample := d["sample"].(string)
    if sample != "" {
      models.Db.Exec("UPDATE samples SET name = ?, vector_id = ? WHERE id = ? ", sample, d["vector_id"], d["sample_id"])
    }
    models.Db.Exec("UPDATE reactions SET remark = ?, primer_id = ? WHERE id = ?", d["remark"], d["primer_id"], d["id"])
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, err)
  }
}
