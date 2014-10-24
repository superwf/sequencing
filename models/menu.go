package models

type Menu struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Url string `json:"url"`
  ParentId int `json:"parent_id"`
}

// get the children of root menu
// tested
func (m *Menu) Children(u *User) []Menu {
  var submenus []Menu
  if u.Admin() {
    Db.Where("parent_id = ?", m.Id).Find(&submenus)
  } else {
    role := Role{Id: u.RoleId}
    Db.Find(&role).Where("parent_id = ?", m.Id).Related(&submenus, "Menus")
  }
  return submenus
}

// tested
func Navigation(u *User) []map[string]interface{} {
  var root_menus []Menu
  db := Db.Where("parent_id = 0").Order("id")
  if u.Admin() {
    db.Find(&root_menus)
  } else {
    role := new(Role)
    Db.First(role, u.RoleId)
    db.Model(role).Related(&root_menus, "Menus")
  }

  var result []map[string]interface{}
  for _, root_menu := range(root_menus) {
    root := map[string]interface{}{
      "name": root_menu.Name,
      "url": root_menu.Url}
    sub_menus := root_menu.Children(u)
    if len(sub_menus) > 0{
      var children []map[string]string
      for _, sub_menu := range(sub_menus) {
        children = append(children, map[string]string{
          "name": sub_menu.Name,
          "url": sub_menu.Url})
      }
      root["children"] = children
    }
    result = append(result, root)
  }
  return result
}
