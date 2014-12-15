package models

import (
  "os/exec"
  "log"
  "net/http"
)

type User struct {
  Id int `json:"id"`
  RoleId int `json:"role_id"`
  DepartmentId int `json:"department_id"`
  Name string `json:"name"`
  Email string `json:"email"`
  Password string `json:"password" sql:"-"`
  EncryptedPassword string `json:"encrypted_password"`
}

// tested
func (u User)Admin() bool {
  return u.RoleId == 1 || u.Id == 1
}

// tested
func GetUsers(req *http.Request)([]User, int){
  page := getPage(req)
  db := Db.Model(User{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
  }
  email := req.FormValue("email")
  if email != "" {
    db = db.Where("email LIKE ?", (email + "%"))
  }

  var count int
  db.Count(&count)
  users := []User{}
  all := req.FormValue("all")
  if all != "" {
    db.Find(&users)
  } else {
    db.Limit(PerPage).Offset(page * PerPage).Find(&users)
  }
  return users, count
}

// i do not kown how to emulate the php crypt function in golang, the golang blowfish crypt run in defferent way.
// tested
func Login(user *User)(int, map[string]interface{}){
  errorMessage := map[string]interface{}{"ok": false, "error": "login_error"}
  if user.Email == "" {
    return http.StatusUnauthorized, errorMessage
  }
  Db.Where("email = ?", user.Email).First(user)
  if(user.Id > 0) {
    cmd := exec.Command(`./blowfish.rb`, user.Password, user.EncryptedPassword)
    result, err := cmd.Output()
    log.Println(result)
    if err != nil {
      log.Println(err)
      return http.StatusUnauthorized, errorMessage
    }
    if(string(result) == "1") {
      return http.StatusOK, map[string]interface{}{
        "name": user.Name,
        "email": user.Email,
        "id": user.Id}
    } else {
      return http.StatusUnauthorized, errorMessage
    }
  } else {
    return http.StatusUnauthorized, errorMessage
  }
}
