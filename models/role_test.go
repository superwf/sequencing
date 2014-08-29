package models
import (
  "testing"
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

func TestHasMenus(t *testing.T) {
  prepare_roles(1)
  role := new(Role)
  Db.Model(Role{}).Find(role)
  if role.Id != 1 {
    t.Errorf("get first role error")
  }

  prepare_menus(1)
  menu := new(Menu)
  Db.Model(Menu{}).Find(menu)
  Db.Model(role).Association("Menus").Append(menu)
  //Db.Exec(`TRUNCATE TABLE menus_roles`)
  //Db.Exec(`INSERT INTO menus_roles (menu_id, role_id) VALUES (`+strconv.Itoa(menu.Id) +`, `+strconv.Itoa(role.Id)+`)`)
  if len(role.Menus) == 0 {
    t.Errorf("role has menus error")
  }
}

func TestHasUsers(t *testing.T){
  prepare_roles(2)
  prepare_users(1)
  user := new(User)
  role := new(Role)
  Db.First(user)
  //Db.Last(role)
  //if role.Id != 2 {
  //  t.Errorf("last role id error")
  //}
  Db.Last(role).Association("Users").Append(*user)
  role = new(Role)
  Db.Last(role)
  if role.Name != "role1" {
    t.Errorf("last role name err")
  }
  user = new(User)
  Db.First(user)
  if user.RoleId != 2 {
    t.Errorf("user role_id error")
  }
}
