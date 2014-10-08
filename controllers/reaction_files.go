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
          now := time.Now().UTC().Format(time.RFC3339)
          models.Db.Exec("INSERT INTO reaction_files(reaction_id, uploaded_at) VALUES(" + strconv.Itoa(id) + ", '" + now + "') ON DUPLICATE KEY UPDATE uploaded_at = VALUES(uploaded_at)")
        }
      }
    }
  }
  r.JSON(http.StatusAccepted, Ok_true)
}

// for the upload_sequence_file program to get the upload information
// skip auth in main.go
func ReactionFiles(r render.Render){
  boards := models.ReactionFiles()
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
    //userId := strconv.Itoa(session.Get("id").(int))
    //models.Db.Exec("UPDATE reaction_files SET interpreter_id = ? WHERE reaction_id IN (?)", userId, ids)

    resp.Header().Set("Content-Disposition", "filename=download.zip")
    r.Data(http.StatusOK, buf.Bytes())
  } else {
    r.JSON(http.StatusNotAcceptable, ids)
  }
}
