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
