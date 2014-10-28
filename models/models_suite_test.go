package models_test

import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "github.com/jinzhu/gorm"
	"testing"
)

var Db gorm.DB = models.Db

func TestModels(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "Models Suite")
}

func ClearData() {
  Db.Exec("TRUNCATE TABLE roles")
  Db.Exec("TRUNCATE TABLE users")
  Db.Exec("TRUNCATE TABLE boards")
  Db.Exec("TRUNCATE TABLE flows")
  Db.Exec("TRUNCATE TABLE menus")
  Db.Exec("DELETE FROM procedures")
  Db.Exec("DELETE FROM board_heads")

  Db.Exec("DELETE FROM clients")
  Db.Exec("DELETE FROM companies")
}
