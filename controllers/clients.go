package controllers

import (
  "sequencing/models"
  "github.com/go-martini/martini"
  "net/http"
  "github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
  "os/exec"
  //"strconv"
)

func UpdateClient(params martini.Params, req *http.Request, session sessions.Session, r render.Render) {
  client := models.Client{}
  parseJson(&client, req)
  originClient := models.Client{Id: client.Id}
  models.Db.First(&originClient)
  if(len(client.Password) > 0) {
    cmd := exec.Command(`./blowfish.php`, client.Password)
    result, _ := cmd.Output()
    client.EncryptedPassword = string(result)
  } else {
    if(len(originClient.EncryptedPassword) == 0) {
      cmd := exec.Command(`./blowfish.php`, originClient.Email)
      result, _ := cmd.Output()
      client.EncryptedPassword = string(result)
    } else {
      client.EncryptedPassword = originClient.EncryptedPassword
    }
  }
  models.Db.Save(&client)
  r.JSON(http.StatusOK, Ok_true)
}
