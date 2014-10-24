package models
import (
  "github.com/jinzhu/gorm"
  _ "github.com/go-sql-driver/mysql"
  "fmt"
  "sequencing/config"
  "os"
  "net/http"
  "strconv"
  "time"
)

var Db gorm.DB

var PerPage int = 10

func init() {
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

  env := os.Getenv("GOENV")
  if env != "production"  {
    Db.LogMode(true)
  }

  if err != nil {
    fmt.Println("mysql connection error ", err)
  }
  //Db.DB().SetMaxIdleConns(10)
  //Db.DB().SetMaxOpenConns(100)
}

type Creator struct{
  CreatorId int `json:"creator_id"`
  CreatedAt time.Time `json:"created_at"`
  UpdatedAt time.Time `json:"updated_at"`
}


func getPage(req *http.Request) int {
  page, err := strconv.Atoi(req.FormValue("pager"))
  if err != nil {
    page = 0
  } else {
    page = page - 1
  }
  return page
}


func Now()string{
  return time.Now().UTC().Format(time.RFC3339)
}

func Today()string{
  return time.Now().UTC().Format("2006-01-02")
}
