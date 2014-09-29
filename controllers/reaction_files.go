package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "sequencing/config"
  "net/http"
  //"log"
  "io/ioutil"
  "os"
  "strconv"
  "time"
  "strings"
)

func CreateReactionFile(params martini.Params, req *http.Request, r render.Render){
  board := params["board"]
  file := params["file"]
  config, _ := config.Config["reaction_file"].(map[interface{}]interface{})
  path, _ := config["path"].(string)

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
        var reaction models.Reaction
        models.Db.Table("reactions").Joins("INNER JOIN boards ON reactions.board_id = boards.id").Where("reactions.hole = ? AND boards.sn = ?", hole, board).First(&reaction)
        if reaction.Id > 0 {
          now := time.Now().Format("2006-01-02 03:04:05")
          models.Db.Exec("INSERT INTO reaction_files(reaction_id, updated_at, created_at) VALUES(" + strconv.Itoa(reaction.Id) + "'" + now + "', '" + now + "') ON DUPLICATE KEY UPDATE updated_at = VALUES(updated_at)")
        }
      }
    }
  }
  r.JSON(http.StatusAccepted, Ok_true)
}

func ReactionFiles(r render.Render){
  boards := models.ReactionFiles()
  r.JSON(http.StatusOK, boards)
}
