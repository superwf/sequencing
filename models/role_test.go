package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "strconv"
  "strings"
)

func prepare_roles(roles_count int) {
  Db.Exec("TRUNCATE TABLE roles")
  var sql []string
  for i := 0; i < roles_count; i++ {
    sql = append(sql, `("role` + strconv.Itoa(i) + `")`)
  }
  Db.Exec(`INSERT INTO roles (name) VALUES ` + strings.Join(sql, ","))
}

var _ = Describe("test Role", func(){
  It("test has menus", func(){
    prepare_roles(1)
    role := new(models.Role)
    Db.Model(models.Role{}).Find(role)
    Expect(role.Id).To(Equal(1))
    prepare_menus(1)
    menu := new(models.Menu)
    Db.Model(models.Menu{}).Find(menu)
    Db.Model(role).Association("Menus").Append(menu)
    Expect(len(role.Menus) > 0).To(Equal(true))
  })

  It("test has users", func(){
    prepare_roles(2)
    prepare_users(1)
    user := new(models.User)
    role := new(models.Role)
    Db.First(user)
    Db.Last(role).Association("Users").Append(*user)
    role = new(models.Role)
    Db.Last(role)
    Expect(role.Name).To(Equal("role1"))
    user = new(models.User)
    Db.First(user)
    Expect(user.RoleId).To(Equal(2))
  })
})