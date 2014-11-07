package controllers

import (
  "net/http"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "io"
  "os"
  "path/filepath"
  "sequencing/config"
  "sequencing/models"
  "strconv"
)

func CreateAttachment(params martini.Params, r render.Render, req *http.Request) {
  file, header, err := req.FormFile("file")
  if err != nil {
    r.JSON(http.StatusNotAcceptable, Ok_false)
    return
  }
  defer file.Close()
  fileName := header.Filename
  ext := filepath.Ext(fileName)

  recordId, _ := strconv.Atoi(params["record_id"])
  attachment := models.Attachment{TableName: params["table_name"], RecordId: recordId, Url: "", Name: fileName}
  models.Db.Save(&attachment)

  osPath := config.Config["upload_path"].(string) + "/upload/" + strconv.Itoa(attachment.Id) + ext
  destFile, err := os.Create(osPath)
  defer destFile.Close()
  _, err = io.Copy(destFile, file)
  if err == nil {
    attachment.Url = "/upload/" + strconv.Itoa(attachment.Id) + ext
    models.Db.Save(&attachment)
    r.JSON(http.StatusOK, attachment)
  } else {
    models.Db.Delete(&attachment)
    r.JSON(http.StatusNotAcceptable, err)
  }
}

func GetAttachments(params martini.Params, r render.Render) {
  attachments := []models.Attachment{}
  models.Db.Table("attachments").Where("table_name = ? AND record_id = ?", params["table_name"], params["record_id"]).Find(&attachments)
  r.JSON(http.StatusOK, attachments)
}

func DeleteAttachment(params martini.Params, r render.Render) {
  a := models.Attachment{}
  models.Db.Table("attachments").Where("id = ?", params["id"]).First(&a)
  osPath := config.Config["upload_path"].(string) + a.Url
  os.Remove(osPath)
  models.Db.Delete(&a)
  r.JSON(http.StatusOK, Ok_true)
}
