package config

import (
  yaml "gopkg.in/yaml.v1"
  "io/ioutil"
  "os"
  "fmt"
  "strings"
)
var Config map[interface{}]interface{}

var ReactionFilePath string
var ReactionFileSuffix []string
var Consts map[string]interface{}
var BillStatus []string
var OrderStatus []string

func init() {
  env := os.Getenv("GOENV")
  if env != "development" && env != "production" && env != "test" {
    env = "development"
  }

  var config_file string
  if env == "test" {
    config_file = "../config.yml"
  } else {
    config_file = "config.yml"
  }

  config_content, err := ioutil.ReadFile(config_file)
  if err != nil {
    panic(err)
  }

  config_env := make(map[interface{}]interface{})
  err = yaml.Unmarshal(config_content, &config_env)
  if err != nil {
    panic(err)
  }

  Config = config_env[env].(map[interface{}]interface{})
  Config["env"] = env

  consts := Config["consts"].(map[interface{}]interface{})
  Consts = map[string]interface{}{}
  for k, v := range(consts) {
    Consts[k.(string)] = v
  }
  billStatus := Consts["billStatus"].([]interface{})
  for _, v := range billStatus {
    BillStatus = append(BillStatus, v.(string))
  }
  orderStatus := Consts["orderStatus"].([]interface{})
  for _, v := range orderStatus {
    OrderStatus = append(OrderStatus, v.(string))
  }

  reactionFile := Config["reaction_file"].(map[interface{}]interface{})
  ReactionFilePath, _ = reactionFile["path"].(string)
  s, _ := reactionFile["suffix"].([]interface{})
  for _, str := range s {
    ReactionFileSuffix = append(ReactionFileSuffix, str.(string))
  }
  fmt.Println("The upload reaction file path is " + ReactionFilePath)
  fmt.Println("The reaction file suffix are " + strings.Join(ReactionFileSuffix, " , "))
}
