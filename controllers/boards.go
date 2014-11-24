package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "sequencing/config"
  "net/http"
  "strconv"
  "regexp"
  "strings"
)

// get the record by sn or create it
func CreateBoard(req *http.Request, r render.Render) {
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

func BoardHoleRecords(params martini.Params, r render.Render){
  idsn := params["idsn"]
  board := models.Board{}
  isId, _ := regexp.MatchString(`^\d+$`, idsn)
  col := ""
  if isId {
    col = "id"
  } else {
    col = "sn"
  }
  models.Db.Where(col + " = ?", idsn).First(&board)
  r.JSON(http.StatusOK, board.Records())
}

//func ConfirmBoard(params martini.Params, r render.Render) {
//  id, _ := strconv.Atoi(params["id"])
//  board := models.Board{Id: id}
//  models.Db.First(&board)
//  procedure, err := board.Confirm()
//  if err != nil {
//    r.JSON(http.StatusNotAcceptable, map[string]string{"hint": err.Error()})
//  } else {
//    r.JSON(http.StatusOK, procedure)
//  }
//}

func GetBoard(params martini.Params, r render.Render) {
  idsn := params["idsn"]
  board := models.Board{}
  isId, _ := regexp.MatchString(`^\d+$`, idsn)
  col := ""
  if isId {
    col = "id"
  } else {
    col = "sn"
  }
  models.Db.Where(col + " = ?", idsn).First(&board)
  r.JSON(http.StatusOK, board)
}

func BoardNextProcedure(params martini.Params, r render.Render) {
  id, _ := strconv.Atoi(params["id"])
  board := models.Board{Id: id}
  procedure := board.NextProcedure()
  r.JSON(http.StatusOK, procedure)
}

func SampleBoardPrimers(params martini.Params, r render.Render){
  id, _ := strconv.Atoi(params["id"])
  board := models.Board{Id: id}
  r.JSON(http.StatusOK, board.SampleBoardPrimers())
}

func RetypesetBoard(params martini.Params, r render.Render){
  board := models.Board{}
  models.Db.Where("id = ?", params["id"]).First(&board)
  if board.Status == config.BoardStatus[0] {
    boardHead := models.BoardHead{Id: board.BoardHeadId}
    models.Db.First(&boardHead)
    models.Db.Exec("UPDATE " + boardHead.BoardType + "s SET board_id = 0, hole = '' WHERE board_id = ?", board.Id)
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

// download reaction_board config file
func ReactionBoardConfig(params martini.Params, r render.Render, rw http.ResponseWriter){
  id := params["id"]
  board := models.Board{}
  models.Db.Where("id = ?", id).First(&board)
  head := models.BoardHead{Id: board.BoardHeadId}
  models.Db.First(&head)
  rows := strings.Split(head.Rows, ",")
  cols := strings.Split(head.Cols, ",")
  holeNumber := len(rows) * len(cols)
  data := "Container Name	Plate ID	Description	ContainerType	AppType	Owner	Operator	PlateSealing	SchedulingPref	\n"+ board.Sn + "	" + board.Sn + "	AutoBot	" + strconv.Itoa(holeNumber) + "-Well	Regular	CEXU	CEXU	Septa	1234	\nAppServer	AppInstance	\nSequencingAnalysis	\nWell	Sample Name	Comment	Results Group 1	Instrument Protocol 1	Analysis Protocol 1	\n"

  result, _ := models.Db.Select("reactions.hole, samples.name").Table("reactions").Joins("INNER JOIN samples ON reactions.sample_id = samples.id").Where("reactions.board_id = ?", board.Id).Rows()
  for result.Next() {
    var sample, hole string
    result.Scan(&hole, &sample)
    data = data + hole + "	" + hole + "	" + sample + "	AUTO	Sequencing-50cm-BDV3	AUTO\n"
  }
  rw.Header().Set("Content-Disposition", "attachment; filename=" + board.Sn + ".txt")
  r.Data(http.StatusOK, []byte(data))
}

// update board, only set status and procedure_id
func UpdateBoard(params martini.Params, r render.Render, req *http.Request){
  id, _ := strconv.Atoi(params["id"])
  b := models.Board{Id: id}
  parseJson(&b, req)
  models.Db.Exec("UPDATE boards SET status = ?, procedure_id = ? WHERE id = ?", b.Status, b.ProcedureId, b.Id)
  r.JSON(http.StatusOK, b)
}
