package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
  "strconv"
)

// get the record by sn or create it
func CreateBoard(params martini.Params, req *http.Request, r render.Render) {
  record := models.Board{}
  parseJson(&record, req)

  board_head := models.BoardHead{}
  models.Db.Where("available = 1 AND id = ?", record.BoardHeadId).First(&board_head)
  sn := record.CreateDate.Format("20060102") + "-" + board_head.Name + strconv.Itoa(record.Number)
  board := models.Board{}
  models.Db.Where("sn = ?", sn).First(&board)
  if board.Id > 0 {
    r.JSON(http.StatusOK, board)
  } else {
    models.Db.Save(&record)
    r.JSON(http.StatusOK, record)
  }
}
