package models_test
import (
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
  "sequencing/models"
  "sequencing/config"
  "strconv"
  "net/http"
  "time"
)

func prepare_orders(count int) {
  prepare_clients(1)
  prepare_board_heads(1)
  head := models.BoardHead{}
  Db.First(&head)
  client := models.Client{}
  Db.First(&client)
  for i := 0; i < count; i++ {
    order := models.Order{ClientId: client.Id, BoardHeadId: head.Id, Number: i + 1, CreateDate: time.Now()}
    Db.Save(&order)
  }
}
var _ = Describe("test Order", func(){
  BeforeEach(func(){
    ClearData()
  })
  It("test order.BeforeCreate", func(){
    prepare_orders(1)
    order := models.Order{}
    Db.First(&order)
    Expect(order.Status).To(Equal(config.OrderStatus[0]))
    head := models.BoardHead{Id: order.BoardHeadId}
    Db.First(&head)
    Expect(order.Sn).To(Equal(order.CreateDate.Format("20060102") + "-" + head.Name + strconv.Itoa(order.Number)))
    newOrder := order
    newOrder.Id = 0
    created := Db.Save(&newOrder)
    Expect(created.Error == nil).To(Equal(false))
    Expect(newOrder.Id).To(Equal(0))
  })
  It("test GetOrders", func(){
    prepare_orders(20)
    req := new(http.Request)
    orders, count := models.GetOrders(req)
    Expect(len(orders)).To(Equal(models.PerPage))
    Expect(count).To(Equal(20))

    order := models.Order{}
    Db.First(&order)

    req.Form.Set("sn", order.Sn)
    orders, count = models.GetOrders(req)
    Expect(len(orders)).To(Equal(1))
    Expect(count).To(Equal(1))
    req.Form.Set("sn", "")

    now := time.Now()
    oneDay := time.Hour * 24
    tommorrow := now.Add(oneDay)
    req.Form.Set("date_from", tommorrow.Format("2006-01-02"))
    orders, count = models.GetOrders(req)
    Expect(len(orders)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("date_from", "")

    yestoday := now.Add(-oneDay)
    req.Form.Set("date_to", yestoday.Format("2006-01-02"))
    orders, count = models.GetOrders(req)
    Expect(len(orders)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("date_to", "")

    headId := strconv.Itoa(order.BoardHeadId + 1)
    req.Form.Set("board_head_id", headId)
    orders, count = models.GetOrders(req)
    Expect(len(orders)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("board_head_id", "")

    req.Form.Set("status", "xxxx")
    orders, count = models.GetOrders(req)
    Expect(len(orders)).To(Equal(0))
    Expect(count).To(Equal(0))
    req.Form.Set("status", "")
  })

  It("test order.GenerateReworkSn", func(){
    prepare_orders(1)
    o := models.Order{}
    Db.First(&o)
    head := models.BoardHead{}
    Db.First(&head)
    order := models.Order{BoardHeadId: head.Id, CreateDate: time.Now()}
    order.GenerateReworkSn(&o)
    Expect(order.Sn).To(Equal(o.Sn + "-" + head.Name + order.CreateDate.Format("0102")))
  })
})
