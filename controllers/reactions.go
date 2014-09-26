package controllers

import (
  "github.com/martini-contrib/render"
  //"github.com/go-martini/martini"
  "sequencing/models"
  "strconv"
  "net/http"
  "log"
)

func TypesetReactionSampleBoards(req *http.Request, r render.Render) {
  sampleBoards := models.TypesetingReactionSampleBoards()
  r.JSON(http.StatusOK, sampleBoards)
}

func UpdateReactions(req *http.Request, r render.Render){
  var reactions []models.Reaction
  parseJson(&reactions, req)
  log.Println(reactions)
  for _, reaction := range(reactions) {
    models.Db.Exec("UPDATE reactions SET board_id = " + strconv.Itoa(reaction.BoardId) + ", hole = '" + reaction.Hole + "' WHERE id = " + strconv.Itoa(reaction.Id))
  }
  r.JSON(http.StatusOK, Ok_true)
}
