package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "sequencing/models"
  "sequencing/config"
  "net/http"
  "log"
  "io/ioutil"
)

func CreateReactionFile(params martini.Params, req *http.Request, r render.Render){
  board := params["board"]
  file := params["file"]
  config, _ := config.Config["reaction_file"].(map[string]string)
  path, _ := config["path"]
  log.Println(path + "/" + board + "/" + file)
  _, err := ioutil.ReadAll(req.Body)
  if err != nil {
    log.Fatal(err)
  } else {
    //log.Println(body)
  }
  r.JSON(http.StatusOK, Ok_true)
}

func ReactionFileBoards(r render.Render){
  boards := models.ReactionFileBoards()
  r.JSON(http.StatusOK, boards)
}
