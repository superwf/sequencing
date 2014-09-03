package models
import (
  "strconv"
  "strings"
  "testing"
)

func prepare_menus(menu_count int) {
  Db.Exec("TRUNCATE TABLE menus")
  var sql []string
  for i := 0; i < menu_count; i++ {
    sql = append(sql, `("menu` + strconv.Itoa(i) + `", "/url")`)
  }
  Db.Exec(`INSERT INTO menus (name, url) VALUES ` + strings.Join(sql, ","))
}

func TestMenuChildren(t *testing.T) {
  prepare_menus(2)
  child_menu := new(Menu)
  root_menu := new(Menu)
  Db.First(root_menu)
  Db.Last(child_menu)
  if root_menu.Id != 1 {
    t.Errorf("children menu test error")
  }
  Db.Model(child_menu).Update("parent_id", root_menu.Id)
  Db.Last(child_menu)
  // test admin user first
  u := User{Id: 1}
  children := root_menu.Children(&u)
  if len(children) == 0 {
    t.Errorf("children menu test error")
  }
  if children[0].Id != child_menu.Id {
    t.Errorf("children menu test error")
  }

  // test normal admin user
  prepare_roles(2)
  prepare_users(2)
  user := new(User)
  Db.Last(user).Update("role_id", 2)
  Db.First(user)
  if user.RoleId != 2 {
    t.Errorf("user`s role_id not updated")
  }
  Db.Exec("TRUNCATE TABLE menus_roles")
  children = root_menu.Children(user)
  if len(children) != 0 {
    t.Errorf("children length error")
  }
  Db.Exec("INSERT INTO menus_roles(menu_id, role_id) VALUES(1, 2),(2, 2)")
  children = root_menu.Children(user)
  if len(children) != 1 {
    t.Errorf("children length is ", len(children))
  }
}

func TestiAdminUserMenu(t *testing.T) {
  prepare_users(1)
  user := new(User)
  Db.First(user)
  prepare_menus(5)
  Db.Exec("TRUNCATE TABLE menus_roles")
  Db.Exec("UPDATE menus SET parent_id = 1 WHERE id = 5")
  menus := Navigation(user)
  if len(menus) != 4 {
    t.Errorf("admin`s menus count error")
  }
  if len(menus[0]["children"].([]map[string]string)) != 1 {
    t.Errorf("children menus count error")
  }
}

func TestNoAdminUserMenu(t *testing.T) {
  prepare_users(2)
  user := new(User)
  Db.Last(user)
  prepare_menus(5)
  prepare_roles(2)
  Db.Exec("UPDATE menus SET parent_id = 1 WHERE id = 5")
  Db.Exec("UPDATE menus SET parent_id = 1 WHERE id = 4")
  menu1, menu4, menu5 := Menu{}, Menu{}, Menu{}
  Db.First(&menu1)
  Db.First(&menu4, 4)
  Db.First(&menu5, 5)
  Db.Exec("TRUNCATE TABLE menus_roles")
  Db.Exec("INSERT INTO menus_roles (menu_id, role_id) VALUES("+strconv.Itoa(menu1.Id)+", 2), ("+strconv.Itoa(menu4.Id)+", 2), ("+strconv.Itoa(menu5.Id)+", 2)")
  user.RoleId = 2
  Db.Save(user)
  menus := Navigation(user)
  if len(menus) != 1 {
    t.Errorf("user`s menus count %d", len(menus))
  }
  //t.Errorf("aaaaaaaaaaaaaaa", len(menus[0]["children"].([]map[string]string)))
  if len(menus[0]["children"].([]map[string]string)) != 2 {
    t.Errorf("children menus count error")
  }
}
