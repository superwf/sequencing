package controllers

import (
  "sequencing/models"
  //"github.com/go-martini/martini"
  "net/http"
  "github.com/martini-contrib/sessions"
  "github.com/martini-contrib/render"
  "encoding/json"
  "log"
  "os/exec"
  "os"
  //"strconv"
)

type sessionData map[string]interface{}

func GetUsers(req *http.Request, r render.Render) {
  users, count := models.GetUsers(req)
  result := map[string]interface{}{
    "records": users,
    "totalItems": count,
    "perPage": models.PerPage}
  r.JSON(http.StatusOK, result)
}

func Me(session sessions.Session) []byte {
  if data := session.Get("me"); data != nil {
    //var user_map map[string]interface{}
    //json.Unmarshal(data, &user_map)
    //user := models.User{Id: user_map["id"].(int)}
    //models.Db.First(&user)
    //r.JSON(http.StatusOK, data)
    return data.([]byte)
  } else {
    return []byte{}
  }
}

func Login(req *http.Request, session sessions.Session, r render.Render) {
  user := models.User{}
  parseJson(&user, req)
  http_status, user_map := models.Login(&user)
  if id, ok := user_map["id"]; ok && id.(int) > 0 {
    user_map["menus"] = models.Navigation(&user)
    delete(user_map, "password")
    delete(user_map, "encrypted_password")
    data, err := json.Marshal(user_map)
    if err != nil {
      log.Fatal("session marshal error: ", err)
    } else {
      session.Set("me", data)
      session.Set("id", id)
    }
  }
  r.JSON(http_status, user_map)
}

func Logout(session sessions.Session, r render.Render) {
  session.Clear()
  r.JSON(http.StatusOK, Ok_true)
}

func UpdatePassword(req *http.Request, session sessions.Session, r render.Render) {
  d := map[string]string{}
  parseJson(&d, req)
  id := session.Get("id").(int)

  if(len(d["oldpassword"]) > 0 && len(d["password"]) > 0 && len(d["confirm_password"]) > 0 && d["confirm_password"] == d["password"]) {
    me := models.User{Id: id}
    models.Db.First(&me)
    gopath := os.Getenv("GOPATH")
    blowfish := gopath + "/src/sequencing/blowfish.rb"
    cmd := exec.Command(blowfish, d["oldpassword"], me.EncryptedPassword)
    result, _ := cmd.Output()
    if(string(result) == "1") {
      cmd = exec.Command(blowfish, d["password"])
      result, _ := cmd.Output()
      models.Db.Exec("UPDATE users SET encrypted_password = ? WHERE id = ?", string(result), id)
    }
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}
