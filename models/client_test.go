package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "strconv"
  "strings"
  "time"
  //"errors"
  //"net/http"
)

func prepare_clients(count int) {
  prepare_companies(1)
  company := models.Company{}
  Db.First(&company)
  var sql []string
  var n string
  var now string = time.Now().String()
  companyId := strconv.Itoa(company.Id)
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "client`+ n +`@c.com", `+companyId+`, "", 1, "`+now+`", "`+now+`")`)
  }
  Db.Exec(`INSERT INTO clients (name, email, company_id, encrypted_password, creator_id, created_at, updated_at) VALUES ` + strings.Join(sql, ","))
}

var _ = Describe("test Client", func(){
  BeforeEach(func(){
    ClearData()
  })
  It("test client.BeforeSave", func(){
    prepare_clients(1)
    c := models.Client{}
    Db.First(&c)
    c.Name = ""
    for i := 0; i < 256; i++ {
      c.Name += "a"
    }
    saved := Db.Save(&c)
    Expect(saved.Error == nil).To(Equal(false))
    c.Name = "a"

    c.Email = ""
    for i := 0; i < 256; i++ {
      c.Email += "a"
    }
    saved = Db.Save(&c)
    Expect(saved.Error == nil).To(Equal(false))
  })
})
