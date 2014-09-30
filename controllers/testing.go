package controllers
import (
  "net/http"
  "sequencing/config"
  "log"
  "github.com/martini-contrib/render"
)
func Testing(req *http.Request, r render.Render){
  path := config.ReactionFilePath
  suffix := config.ReactionFileSuffix
  log.Println(config.ReactionFilePath)
  log.Println(suffix)
  r.JSON(http.StatusOK, path)
}
