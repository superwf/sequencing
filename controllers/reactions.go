package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
  "strconv"
)

func TypesetReactions(req *http.Request, r render.Render) {
  sampleBoards := TypesetingReactionSampleBoards()
  r.JSON(http.StatusOK, sampleBoards)
}
