package models
import (
  "testing"
  "net/http"
  "strconv"
  "strings"
  "time"
)

func prepare_user () {
  Db.Exec("TRUNCATE TABLE users")
  user := User{
    Name: "hongyan",
    DepartmentId: 1,
    RoleId: 1,
    Email: "hongyan@chgb.org.cn",
    Password: "hongyanhongyan",
    EncryptedPassword: "$2a$10$4mRbqPW3vvenvzRniw4vU.g.1AFh8c/S1TJ8DviY4r50iLI7VMtX6"}
  Db.Save(&user)
}

func prepare_users(users_count int) {
  Db.Exec("TRUNCATE TABLE users")
  var sql []string
  var n string
  var now string = time.Now().String()
  for i := 0; i < users_count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "name`+ n +`@chgb.org", 1, 1, "xxxxx", "`+now+`", "`+now+`")`)
  }
  Db.Exec(`INSERT INTO users (name, email, role_id, department_id, encrypted_password, created_at, updated_at) VALUES ` + strings.Join(sql, ","))
}

func TestLogin(t *testing.T) {
  prepare_user()
  user := User{
    Email: "hongyan@chgb.org.cn",
    Password: "hongyanhongyan"}
  status, _ := Login(&user)
  if status != http.StatusOK {
    t.Errorf("login password validation fail")
  }

  user.Password = "wrongpassword"
  status, _ = Login(&user)
  if status != http.StatusUnauthorized {
    t.Errorf("login password validation fail")
  }

  user.Email = "nouser@chgb.org.cn"
  status, _ = Login(&user)
  if status != http.StatusUnauthorized {
    t.Errorf("login password validation fail")
  }
}

func TestGetUsers(t *testing.T) {
  users_count := 20
  prepare_users(users_count)
  var count int
  Db.Model(User{}).Count(&count)
  if count != 20 {
    t.Errorf("user count error")
  }

  req := new(http.Request)
  users, count := GetUsers(req)
  if len(users) != PerPage {
    t.Errorf("perpage length error")
  }

  if users[0].Name != "name0" {
    t.Errorf("first user name error")
  }
}

func TestUserRole(t *testing.T){
  var user User
  Db.First(&user)
  prepare_roles(1)
  var role_count int
  Db.Model(Role{}).Count(&role_count)
  if role_count != 1 {
    t.Errorf("role count error")
  }
  var role Role
  Db.Model(&user).Related(&role)
  if role.Id != user.RoleId {
    t.Errorf("first user`s role get error")
  }
}

func TestAdmin(t *testing.T) {
  u := new(User)
  if u.Admin() {
    t.Errorf("no admin user is Admin error")
  }
  u.RoleId = 1
  if !u.Admin() {
    t.Errorf("role_id 1 is Admin")
  }
  u.RoleId = 0
  u.Id = 1
  if !u.Admin() {
    t.Errorf("id 1 is Admin")
  }
}
