package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "net/http"
  "strconv"
  "strings"
  "time"
  "errors"
)

func prepare_companies(count int) {
  models.Db.Exec("DELETE FROM clients")
  models.Db.Exec("DELETE FROM companies")
  var sql []string
  var n string
  var now string = time.Now().String()
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "000`+ n +`", 1, "`+now+`", "`+now+`")`)
  }
  Db.Exec(`INSERT INTO companies (name, code, creator_id, created_at, updated_at) VALUES ` + strings.Join(sql, ","))
}
var _ = Describe("test Company", func(){
  It("test GetCompanies", func(){
    prepare_companies(20)
    req := new(http.Request)
    companies, count := models.GetCompanies(req)
    Expect(count).To(Equal(20))
    Expect(len(companies)).To(Equal(models.PerPage))

    req.Form.Set("name", "name3")
    companies, count = models.GetCompanies(req)
    Expect(count).To(Equal(1))

    req.Form.Set("name", "")
    req.Form.Set("code", "0001")
    companies, count = models.GetCompanies(req)
    Expect(count).To(Equal(11))

    req.Form.Set("absolute_code", "true")
    req.Form.Set("code", "0001")
    companies, count = models.GetCompanies(req)
    Expect(count).To(Equal(1))
  })

  It("test GenerateFullName and GenerateFullCode", func(){
    prepare_companies(1)
    first := models.Company{}
    models.Db.First(&first)
    c := models.Company{Name: "nnn", ParentId: first.Id, Code: "003"}
    c.GenerateFullName()
    Expect(c.FullName).To(Equal(first.Name + "-" + c.Name))

    c.GenerateFullCode()
    Expect(c.FullCode).To(Equal(first.Code + c.Code))
  })

  It("test company.BeforeSave", func(){
    prepare_companies(1)
    c := models.Company{}
    models.Db.First(&c)
    for i := 0; i < 256; i++ {
      c.Name += "a"
    }
    result := models.Db.Save(&c)
    Expect(result.Error).To(Equal(errors.New("name length error")))

    c.Name = ""
    result = models.Db.Save(&c)
    Expect(result.Error).To(Equal(errors.New("name length error")))

    c.Name = "a"
    result = models.Db.Save(&c)
    Expect(result.Error == nil).To(Equal(true))

    for i := 0; i < 256; i++ {
      c.Code += "a"
    }
    result = models.Db.Save(&c)
    Expect(result.Error).To(Equal(errors.New("code length error")))

    c.Code = ""
    result = models.Db.Save(&c)
    Expect(result.Error).To(Equal(errors.New("code length error")))
    c.Code = "a"

    c.ParentId = c.Id
    result = models.Db.Save(&c)
    Expect(result.Error).To(Equal(errors.New("parent self_parent")))
  })

  It("test company.Children and company.ChildrenCount and company.Parent", func(){
    prepare_companies(2)
    first := models.Company{}
    models.Db.Order("id ASC").First(&first)
    last := models.Company{}
    models.Db.Order("id DESC").First(&last)
    models.Db.Exec("UPDATE companies SET parent_id = ? WHERE id = ?", first.Id, last.Id)
    children := first.Children()
    Expect(len(children)).To(Equal(1))
    Expect(first.ChildrenCount()).To(Equal(1))
    models.Db.First(&last)
    Expect(last.Parent().Id).To(Equal(first.Id))
  })

  It("test BeforeDelete", func(){
    prepare_companies(2)
    first := models.Company{}
    models.Db.Order("id ASC").First(&first)
    last := models.Company{}
    models.Db.Order("id DESC").First(&last)
    models.Db.Exec("UPDATE companies SET parent_id = ? WHERE id = ?", first.Id, last.Id)
    result := models.Db.Delete(&first)
    Expect(result.Error).To(Equal(errors.New("children company exist")))
  })

  It("test client company_id foreign key restrict", func(){
    prepare_clients(1)
    //Expect(result.Error == nil).To(Equal(true))
    count := 0
    models.Db.Table("clients").Count(&count)
    Expect(count).To(Equal(1))
    company := models.Company{}
    models.Db.First(&company)
    models.Db.Delete(&company)
    models.Db.Table("clients").Count(&count)
    Expect(count).To(Equal(1))
  })
})
