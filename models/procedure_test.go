package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "strconv"
  "strings"
  "net/http"
)

func prepareProcedures(count int) {
  Db.Exec("TRUNCATE TABLE procedures")
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("procedure` + n + `", "remark", "sample", 1, 0, 1)`)
  }
  Db.Exec("INSERT INTO procedures(name, `remark`, `flow_type`, board, attachment, creator_id) VALUES " + strings.Join(sql, ","))
}

var _ = Describe("test procedure", func(){
  It("test get procedures", func(){
    prepareProcedures(2)
    procedures := models.GetProcedures()
    Expect(len(procedures)).To(Equal(2))
    Expect(procedures[1].Id).To(Equal(2))
  })

  It("test validate name", func(){
    p := models.Procedure{
      Name: "procedure1",
      Remark: "remark1",
      FlowType: "sample",
      Board: true,
      Attachment: true}
    var status int
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusAccepted))
    p.Name = ""
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
    p.Name = "a"
    for i := 0; i < 101; i++ {
      p.Name = p.Name + "a"
    }
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
  })

  It("test validate remark", func(){
    p := models.Procedure{
      Name: "procedure1",
      Remark: "remark1",
      FlowType: "sample",
      Board: true,
      Attachment: true}
    var status int
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusAccepted))
    p.Remark = ""
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
    p.Remark = "a"
    for i := 0; i < 101; i++ {
      p.Remark = p.Remark + "a"
    }
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
  })

  It("test validate flow_type", func(){
    p := models.Procedure{
      Name: "procedure1",
      Remark: "remark1",
      FlowType: "sample",
      Board: true,
      Attachment: true}
    var status int
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusAccepted))
    p.FlowType = ""
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
    p.FlowType = "abcedf"
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusNotAcceptable))
    p.FlowType = "reaction"
    status, _ = p.ValidateSave()
    Expect(status).To(Equal(http.StatusAccepted))
  })
})
