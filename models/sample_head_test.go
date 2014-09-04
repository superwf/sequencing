package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "strconv"
  "strings"
)

func prepare_sample_heads(count int) {
  Db.Exec("TRUNCATE TABLE sample_heads")
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("head` + n + `", "remark", 0, 1)`)
  }
  Db.Exec("INSERT INTO sample_heads(name, remark, auto_precheck, available) VALUES " + strings.Join(sql, ","))
}

var _ = Describe("test SampleHead", func(){
  It("test get sample_heads", func(){
    prepare_sample_heads(3)
    h := new(models.SampleHead)
    Db.First(h)
    Expect(h.Name).To(Equal("head0"))
  })
})
