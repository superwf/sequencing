package controllers

import(
  "net/http"
  "sequencing/config"
  "github.com/martini-contrib/render"
)

func Consts(r render.Render){
  r.JSON(http.StatusOK, config.Consts)
}
