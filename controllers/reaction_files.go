package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "github.com/go-martini/martini"
  "sequencing/models"
  "sequencing/config"
  "net/http"
  "io/ioutil"
  "os"
  "strconv"
  "time"
  "strings"
  "archive/zip"
  "bytes"
  "encoding/json"
  //"log"
)

// for the upload_sequence_file program to post reaciton file
// skip auth in main.go
func CreateReactionFile(params martini.Params, req *http.Request, r render.Render){
  board := params["board"]
  file := params["file"]
  path := config.ReactionFilePath

  boardPath := path + "/" + board
  _, err := os.Stat(boardPath)
  if os.IsNotExist(err) {
    os.Mkdir(boardPath, 0770)
  }

  filePath := boardPath + "/" + file
  //log.Println(filePath)
  body, err := ioutil.ReadAll(req.Body)
  if err != nil {
    panic(err)
  } else {
    f, err := os.OpenFile(filePath, os.O_CREATE|os.O_RDWR, 0660)
    defer f.Close()
    if err != nil {
      panic(err)
    } else {
      _, err = f.Write(body)
      if err != nil {
        panic(err)
      } else {
        fileBase := strings.Split(file, ".")
        hole := fileBase[0]
        var id int
        models.Db.Table("reactions").Select("reactions.id").Joins("INNER JOIN boards ON reactions.board_id = boards.id").Where("reactions.hole = ? AND boards.sn = ?", hole, board).Limit(1).Row().Scan(&id)
        if id > 0 {
          now := models.Now()
          models.Db.Exec("INSERT INTO reaction_files(reaction_id, uploaded_at) VALUES(" + strconv.Itoa(id) + ", '" + now + "') ON DUPLICATE KEY UPDATE uploaded_at = VALUES(uploaded_at)")
        }
      }
    }
  }
  r.JSON(http.StatusAccepted, Ok_true)
}

// for the upload_sequence_file program to get the upload information
// skip auth in main.go
func UploadingReactionBoards(r render.Render){
  boards := models.UploadingReactionBoards()
  r.JSON(http.StatusOK, boards)
}

func DownloadingReactionFiles(req *http.Request, r render.Render){
  result := models.DownloadingReactionFiles(req)
  r.JSON(http.StatusOK, result)
}

func DownloadReactionFiles(req *http.Request, r render.Render, resp http.ResponseWriter, session sessions.Session){
  ids := strings.Split(req.FormValue("ids"), ",")
  if len(ids) > 0 {
    path := config.ReactionFilePath

    rows, _ := models.Db.Table("reactions").Select("boards.sn, reactions.hole, reactions.id").Joins("INNER JOIN boards ON reactions.board_id = boards.id").Where("reactions.id IN(?)", ids).Rows()
    //var result []byte

    buf := new(bytes.Buffer)
    w := zip.NewWriter(buf)

    for rows.Next(){
      var board, hole string
      var id int
      rows.Scan(&board, &hole, &id)
      for _, s := range config.ReactionFileSuffix {
        fileName := hole + s
        file := path + "/" + board + "/" + fileName
        _, err := os.Stat(file)
        if err == nil {
          f, _ := w.Create(fileName)
          content, err := ioutil.ReadFile(file)
          if err == nil {
            f.Write(content)
            //result = append(result, content...)
          }
        }
      }
    }
    w.Close()
    userId := strconv.Itoa(session.Get("id").(int))
    models.Db.Exec("UPDATE reaction_files SET interpreter_id = ? WHERE reaction_id IN (?)", userId, ids)

    resp.Header().Set("Content-Disposition", "filename=download.zip")
    r.Data(http.StatusOK, buf.Bytes())
  } else {
    r.JSON(http.StatusNotAcceptable, ids)
  }
}


func InterpretingReactionFiles(r render.Render, session sessions.Session){
  // get the abi_record procedure id
  procedure := models.Procedure{}
  models.Db.Where("record_name = 'abi_records'").First(&procedure)
  if procedure.Id > 0 {
    userId := strconv.Itoa(session.Get("id").(int))
    rows, _ := models.Db.Select("reaction_files.reaction_id, reaction_files.uploaded_at, samples.name, sample_boards.sn, samples.hole, orders.sn, primers.name, reaction_boards.sn, reactions.hole, board_records.data, clients.name, reaction_files.proposal").Table("reaction_files").Joins("LEFT JOIN interprete_codes ON reaction_files.code_id = interprete_codes.id INNER JOIN reactions ON reaction_files.reaction_id = reactions.id INNER JOIN samples ON reactions.sample_id = samples.id INNER JOIN orders ON samples.order_id = orders.id INNER JOIN boards AS sample_boards ON sample_boards.id = samples.board_id INNER JOIN boards AS reaction_boards ON reaction_boards.id = reactions.board_id INNER JOIN clients ON orders.client_id = clients.id INNER JOIN primers ON reactions.primer_id = primers.id INNER JOIN board_records ON reactions.board_id = board_records.board_id").Where("reaction_files.status = 'interpreting' AND reaction_files.interpreter_id = ? AND board_records.procedure_id = ?", userId, procedure.Id).Rows()
    result := []map[string]interface{}{}
    for rows.Next() {
      var id int
      var uploadTime time.Time
      var sample, sampleBoard, sampleHole, reactionBoard, reactionHole, order, client, primer, instrument, proposal string
      rows.Scan(&id, &uploadTime, &sample, &sampleBoard, &sampleHole, &order, &primer, &reactionBoard, &reactionHole, &instrument, &client, &proposal)
      d := map[string]interface{}{
        "id": id,
        "client": client,
        "order": order,
        "sample": sample,
        "sample_board": sampleBoard,
        "sample_hole": sampleHole,
        "primer": primer,
        "reaction_board": reactionBoard,
        "reaction_hole": reactionHole,
        "upload_time": uploadTime,
        "instrument": instrument,
      }
      result = append(result, d)
    }
    r.JSON(http.StatusOK, result)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

func Interprete(req *http.Request, r render.Render, session sessions.Session){
  var records []map[string]interface{}
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&records)
  if err != nil { panic(err) }
  if len(records) > 0 {
    now := models.Now()
    for _, d := range(records) {
      //if codeId, ok := d["code_id"]; ok {
      //  update = append(update, "SET code_id = ?")
      //}
      models.Db.Exec("UPDATE reaction_files SET code_id = ?, interpreted_at = ?, proposal = ?, status = ? WHERE reaction_id = ?", d["code_id"], now, d["proposal"], d["status"], d["id"])
    }
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

func InterpretedReactionFiles(params martini.Params, r render.Render){
  orderId, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: orderId}
  r.JSON(http.StatusOK, order.InterpretedReactionFiles())
}
