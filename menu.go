package main
import (
  "github.com/jinzhu/gorm"
  _ "github.com/go-sql-driver/mysql"
  "fmt"
  "sequencing/config"
)

var Db gorm.DB

type Menu struct {
  Id int64 `json:"id"`
  Name string `json:"name"`
  Url string `json:"url"`
}

type Role struct {
  Id int `json:"id"`
  Name string `json:"name"`
  Menus []Menu `gorm:"many2many:menus_roles"`
}

func (m *Menu) Children() []Menu {
  var submenus []Menu
  Db.Model(Menu{}).Where("parent_id = ?", m.Id).Find(&submenus)
  return submenus
}

func main() {

  var err error
  mysql_config := config.Config["mysql"].(map[interface{}]interface{})
  //fmt.Println(mysql_config)

  //db, err = gorm.Open("mysql", "root:1@tcp(localhost:3306)/sequencing?charset=utf8&parseTime=True")
  mysql_source := mysql_config["user"].(string) +
  ":" + mysql_config["password"].(string) +
  "@" + mysql_config["network"].(string) +
  "(" + mysql_config["host"].(string) +
  ":" + mysql_config["port"].(string) +
  ")/"+ mysql_config["database"].(string) +
  "?charset=utf8&parseTime=True"
  //fmt.Println(mysql_source)
  Db, err = gorm.Open("mysql", mysql_source)

  Db.LogMode(true)
  if err != nil {
    fmt.Println("mysql connection error ", err)
  }

  var menus []Menu
  role := new(Role)
  Db.First(role).Where("parent_id IS NULL").Related(&menus, "Menus")
  fmt.Println(menus)
}
