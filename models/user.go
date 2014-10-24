package models

import (
  "os/exec"
  //"github.com/jinzhu/gorm"
  "log"
  "time"
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
  CreatedAt time.Time
  UpdatedAt time.Time
}

func (u User)Admin() bool {
  return u.RoleId == 1 || u.Id == 1
}

func GetUsers(req *http.Request)([]User, int){
  page := getPage(req)
  db := Db.Model(User{})
  name := req.FormValue("name")
  if name != "" {
    db = db.Where("name LIKE ?", (name + "%"))
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
func Login(user *User)(int, map[string]interface{}){
  if user.Email == "" {
    return http.StatusUnauthorized, map[string]interface{}{"ok": false, "error": "login_error"}
  }
  Db.Where("email = ?", user.Email).First(user)
  if(user.Id > 0) {
    cmd := exec.Command(`./blowfish.php`, user.Password, user.EncryptedPassword)
    result, err := cmd.Output()
    if err != nil {
      log.Println(err)
      return http.StatusUnauthorized, map[string]interface{}{"ok": false, "error": "password encrypt error"}
    }
    if(string(result) == "1") {
      return http.StatusOK, map[string]interface{}{
        "name": user.Name,
        "email": user.Email,
        "id": user.Id}
    } else {
      return http.StatusUnauthorized, map[string]interface{}{"ok": false, "error": "login_error"}
    }
  } else {
    return http.StatusUnauthorized, map[string]interface{}{"ok": false, "error": "login_error"}
  }
}
