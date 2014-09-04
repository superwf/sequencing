package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "net/http"
  "strconv"
  "strings"
  "time"
)

func prepare_user () {
  models.Db.Exec("TRUNCATE TABLE users")
  user := models.User{
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

var _ = Describe("test User", func(){
  It("test login", func(){
    prepare_user()
    user := models.User{
      Email: "hongyan@chgb.org.cn",
      Password: "hongyanhongyan"}
    status, _ := models.Login(&user)
    Expect(status).To(Equal(http.StatusOK))

    user.Password = "wrongpassword"
    status, _ = models.Login(&user)
    Expect(status).To(Equal(http.StatusUnauthorized))
    user.Email = "nouser@chgb.org.cn"
    status, _ = models.Login(&user)
    Expect(status).To(Equal(http.StatusUnauthorized))
  })

  It("test GetUsers", func(){
    users_count := 20
    prepare_users(users_count)
    var count int
    Db.Model(models.User{}).Count(&count)
    Expect(count).To(Equal(users_count))

    req := new(http.Request)
    users, count := models.GetUsers(req)
    Expect(len(users)).To(Equal(models.PerPage))

    Expect(users[0].Name).To(Equal("name0"))
  })

  It("test user role", func(){
    var user models.User
    Db.First(&user)
    prepare_roles(1)
    var role_count int
    Db.Model(models.Role{}).Count(&role_count)
    Expect(role_count).To(Equal(1))
    var role models.Role
    Db.Model(&user).Related(&role)
    Expect(role.Id).To(Equal(user.RoleId))
  })

  It("test Admin", func(){
    u := new(models.User)
    Expect(u.Admin()).To(Equal(false))
    u.RoleId = 1
    Expect(u.Admin()).To(Equal(true))
    u.RoleId = 0
    u.Id = 1
    Expect(u.Admin()).To(Equal(true))
  })
})
