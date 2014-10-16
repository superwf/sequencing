package controllers

import (
  "net/http"
  "sequencing/config"
  "sequencing/models"
  "github.com/martini-contrib/render"
)

func Config(req *http.Request, r render.Render){
  req.Form = map[string][]string{
    "all": []string{"true"},
  }
  users, _ := models.GetUsers(req)
  procedures, _ := models.GetProcedures(req)
  boardHeads, _ := models.GetBoardHeads(req)
  plasmidCodes, _ := models.GetPlasmidCodes(req)
  precheckCodes, _ := models.GetPrecheckCodes(req)
  interpreteCodes, _ := models.GetInterpreteCodes(req)
  result := map[string]interface{}{
    "config": config.Consts,
    "users": users,
    "procedures": procedures,
    "boardHeads": boardHeads,
    "plasmidCodes": plasmidCodes,
    "precheckCodes": precheckCodes,
    "interpreteCodes": interpreteCodes,
  }
  r.JSON(http.StatusOK, result)
}
