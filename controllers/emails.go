package controllers

import (
  "github.com/martini-contrib/render"
  "sequencing/models"
  "sequencing/config"
  "net/http"
  "github.com/martini-contrib/sessions"
)

func SendingOrderEmails(r render.Render){
  r.JSON(http.StatusOK, models.SendingOrderEmails())
}

// todo generate rework order
func CreateEmail(req *http.Request, r render.Render, session sessions.Session){
  record := models.Email{}
  parseJson(&record, req)
  record.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&record)
  if saved.Error != nil {
    r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": saved.Error.Error()})
  } else {
    if record.EmailType == config.EmailType[2] {
      order := models.Order{Id: record.RecordId}
      order.SubmitInterpretedReactionFiles()
    }
    r.JSON(http.StatusOK, record)
  }
}

func SubmitInterpretedReactionFiles(req *http.Request, r render.Render){
  record := map[string]int{}
  parseJson(&record, req)
  id, ok := record["id"]
  if ok && id > 0 {
    order := models.Order{Id: id}
    order.SubmitInterpretedReactionFiles()
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}
