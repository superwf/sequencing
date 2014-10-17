package controllers

import(
  "net/http"
  "github.com/martini-contrib/render"
  "sequencing/models"
)

func GetClientReactions(req *http.Request, r render.Render){
  reactions := models.GetClientReactions(req)
  r.JSON(http.StatusOK, reactions)
}

func DeleteClientReactions(req *http.Request, r render.Render){
  req.ParseForm()
  ids := req.Form["ids"]
  models.Db.Exec("DELETE FROM client_reactions WHERE id IN (?)", ids)
  r.JSON(http.StatusOK, Ok_true)
}
