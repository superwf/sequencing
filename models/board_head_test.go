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
  var sql []string
  var n string
  for i := 0; i < count; i++ {
    n = strconv.Itoa(i)
    sql = append(sql, `("name` + n + `", "sample", "1,2,3,4", "A,B,C,D", 1)`)
  }
  Db.Exec(`INSERT INTO board_heads (name, board_type, cols, rows, available) VALUES ` + strings.Join(sql, ","))
}

var _ = Describe("test BoardHead", func(){
  BeforeEach(func(){
    ClearData()
  })
  It("test GetBoardHeads", func(){
    prepare_board_heads(20)
    req := new(http.Request)
    boards, count := models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(models.PerPage))
    Expect(count).To(Equal(20))

    req.Form.Set("name", "name3")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(1))
    Expect(count).To(Equal(1))
    req.Form.Set("name", "")

    req.Form.Set("board_type", "xxxxx")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("board_type", "")

    req.Form.Set("is_redo", "true")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(0))
    Expect(count).To(Equal(0))

    req.Form.Set("is_redo", "false")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(models.PerPage))
    Expect(count).To(Equal(20))
    req.Form.Set("is_redo", "")

    req.Form.Set("available", "false")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("available", "")

    req.Form.Set("all", "true")
    boards, count = models.GetBoardHeads(req)
    Expect(len(boards)).To(Equal(20))
    req.Form.Set("all", "")
  })

  It("test BeforeSave", func(){
    prepare_board_heads(1)
    head := models.BoardHead{}
    models.Db.First(&head)
    head.Name = ""
    for i := 0; i < 256; i++ {
      head.Name += "a"
    }
    result := models.Db.Save(&head)
    Expect(result.Error).To(Equal(errors.New("name length error")))
    head.Name = "a"
    result = models.Db.Save(&head)
    Expect(result.Error == nil).To(Equal(true))

    head.Remark = ""
    for i := 0; i < 256; i++ {
      head.Remark += "a"
    }
    result = models.Db.Save(&head)
    Expect(result.Error).To(Equal(errors.New("remark length error")))
    head.Remark = "a"
    result = models.Db.Save(&head)
    Expect(result.Error == nil).To(Equal(true))

    head.BoardType = "xxxx"
    result = models.Db.Save(&head)
    Expect(result.Error).To(Equal(errors.New("board_type error")))
    head.BoardType = "reaction"
    result = models.Db.Save(&head)
    Expect(result.Error == nil).To(Equal(true))
    head.BoardType = "primer"
    result = models.Db.Save(&head)
    Expect(result.Error == nil).To(Equal(true))

    newHead := head
    newHead.Id = 0
    models.Db.Save(&newHead)
    Expect(newHead.Id).To(Equal(0))
    newHead.Name = "newName"
    models.Db.Save(&newHead)
    Expect(newHead.Id == 0).To(Equal(false))

  })

  // orders, flows, boards has restrict foreign key
  // todo orders, boards
  It("test foreign key restrict", func(){
    prepare_flows(1)
    flow := models.Flow{}
    models.Db.First(&flow)
    Expect(flow.BoardHeadId > 0).To(Equal(true))
    head := models.BoardHead{}
    models.Db.First(&head)
    Expect(flow.BoardHeadId).To(Equal(head.Id))
    deleted := Db.Delete(&head)
    Expect(deleted.Error == nil).To(Equal(false))
  })
})
