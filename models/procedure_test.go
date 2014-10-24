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

func prepare_procedures(count int) {
  models.Db.Exec("DELETE FROM flows")
  models.Db.Exec("DELETE FROM procedures")
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "record_name", "sample")`)
  }
  Db.Exec(`INSERT INTO procedures (name, record_name, flow_type) VALUES ` + strings.Join(sql, ","))
}
var _ = Describe("test Procedure", func(){
  It("test GetProcedures", func(){
    prepare_procedures(15)
    req := new(http.Request)
    procedures, count := models.GetProcedures(req)
    Expect(count).To(Equal(15))
    Expect(len(procedures)).To(Equal(models.PerPage))

    req.Form.Set("name", "name3")
    procedures, count = models.GetProcedures(req)
    Expect(count).To(Equal(1))

    req.Form.Set("name", "")
    req.Form.Set("flow_type", "xxxxx")
    procedures, count = models.GetProcedures(req)
    Expect(count).To(Equal(0))

    req.Form.Set("flow_type", "")
    req.Form.Set("board_head_id", "1")
    procedures, count = models.GetProcedures(req)
    Expect(count).To(Equal(0))

    req.Form.Set("board_head_id", "")
    req.Form.Set("all", "true")
    procedures, count = models.GetProcedures(req)
    Expect(len(procedures)).To(Equal(15))
  })
  It("test procedure.BeforeSave", func(){
    prepare_procedures(1)
    p := models.Procedure{}
    models.Db.First(&p)
    for i := 0; i < 256; i++ {
      p.Name += "a"
    }
    result := models.Db.Save(&p)
    Expect(result.Error).To(Equal(errors.New("name length error")))

    p.Name = "a"
    for i := 0; i < 256; i++ {
      p.Remark += "a"
    }
    result = models.Db.Save(&p)
    Expect(result.Error).To(Equal(errors.New("remark length error")))
    p.Remark = ""

    p.FlowType = "reaction"
    result = models.Db.Save(&p)
    Expect(result.Error == nil).To(Equal(true))

    p.FlowType = "xxxx"
    result = models.Db.Save(&p)
    Expect(result.Error).To(Equal(errors.New("flow_type type error")))
  })

  // todo
  It("test procedure.BeforeDelete", func(){
    //prepare_procedures(1)
  })
})
