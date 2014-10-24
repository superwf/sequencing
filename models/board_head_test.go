package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "net/http"
  "strconv"
  "strings"
  "errors"
)

func prepare_board_heads(count int) {
  models.Db.Exec("DELETE FROM flows")
  models.Db.Exec("DELETE FROM board_heads")
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "sample", "1,2,3,4", "A,B,C,D")`)
  }
  Db.Exec(`INSERT INTO board_heads (name, board_type, cols, rows) VALUES ` + strings.Join(sql, ","))
}

var _ = Describe("test BoardHead", func(){
  It("test GetBoardHeads", func(){
  })
})
