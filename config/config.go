package config

import (
  yaml "gopkg.in/yaml.v1"
  "io/ioutil"
  "os"
)
var Config map[interface{}]interface{}

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
}
