package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "net/http"
  "strconv"
)

// get the record by sn or create it
func CreateBoard(req *http.Request, r render.Render) {
  record := models.Board{Status: "new"}
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

func BoardRecords(params martini.Params, r render.Render){
  sn := params["sn"]
  board := models.Board{}
  models.Db.Where("sn = ?", sn).First(&board)
  r.JSON(http.StatusOK, board.Records())
}

func ConfirmBoard(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  board := models.Board{Id: id}
  models.Db.First(&board)
  procedure, err := board.Confirm()
  if err != nil {
    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": err.Error()})
  } else {
    r.JSON(http.StatusOK, procedure)
  }
}

func GetBoard(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  record := models.Board{Id: id}
  models.Db.First(&record)
  r.JSON(http.StatusOK, record)
}

func BoardNextProcedure(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  board := models.Board{Id: id}
  procedure := board.NextProcedure()
  r.JSON(http.StatusOK, procedure)
}
