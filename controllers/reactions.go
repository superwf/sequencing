package controllers

import (
  "github.com/martini-contrib/render"
  "encoding/json"
  "sequencing/models"
  "net/http"
  "strings"
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

func ReactionStatistic(req *http.Request, r render.Render){
  dateFrom := req.FormValue("date_from")
  dateTo := req.FormValue("date_to")
  heads := req.FormValue("heads")
  headsArray := strings.Split(heads, " ")
  data := [][]interface{}{}
  for _, head := range(headsArray) {
    if len(head) > 0 {
      h := models.BoardHead{}
      models.Db.Where("name LIKE ?", head).First(&h)
      if h.Id > 0 {
        var totalCount, interpretedCount, okCount, concessionCount, reworkCount, reshakeCount int
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ?", h.Id, dateFrom, dateTo).Count(&totalCount)
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ? AND reaction_files.code_id > 0", h.Id, dateFrom, dateTo).Count(&interpretedCount)
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ? AND interprete_codes.available = 1 AND interprete_codes.result = 'pass'", h.Id, dateFrom, dateTo).Count(&okCount)
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ? AND interprete_codes.available = 1 AND interprete_codes.result = 'concession'", h.Id, dateFrom, dateTo).Count(&concessionCount)
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ? AND interprete_codes.available = 1 AND interprete_codes.result = 'rework'", h.Id, dateFrom, dateTo).Count(&reworkCount)
        models.Db.Table("reactions").Joins("INNER JOIN orders ON reactions.order_id = orders.id INNER JOIN reaction_files ON reactions.id = reaction_files.reaction_id INNER JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id").Where("orders.board_head_id = ? AND orders.create_date >= ? AND orders.create_date <= ? AND interprete_codes.available = 1 AND interprete_codes.result = 'reshake'", h.Id, dateFrom, dateTo).Count(&reshakeCount)
        d := []interface{}{
          h.Name,
          totalCount,
          interpretedCount,
          okCount,
          concessionCount,
          reworkCount,
          reshakeCount,
        }
        data = append(data, d)
      }
    }
  }
  r.JSON(http.StatusOK, data)
}
