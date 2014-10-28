package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "strconv"
  "time"
)

func prepare_boards(count int) {
  Db.Exec("DELETE FROM boards")
  prepare_board_heads(1)
  head := models.BoardHead{}
  Db.First(&head)
  board := models.Board{BoardHeadId: head.Id, CreateDate: time.Now(), Number: 1}
  Db.Save(&board)
}
var _ = Describe("test Board", func(){
  It("test board.BeforeCreate", func(){
    prepare_board_heads(1)
    head := models.BoardHead{}
    Db.First(&head)
    board := models.Board{BoardHeadId: head.Id, CreateDate: time.Now(), Number: 1}
    Db.Save(&board)
    Expect(board.Sn).To(Equal(board.CreateDate.Format("20060102") + "-" + head.Name + strconv.Itoa(board.Number)))
    Expect(board.Status).To(Equal("new"))
    // test sn can not repeat
    newBoard := board
    newBoard.Id = 0
    Db.Save(&newBoard)
    Expect(newBoard.Id).To(Equal(0))
  })
  It("test GetBoards", func(){
    prepare_boards(1)
  })
})
