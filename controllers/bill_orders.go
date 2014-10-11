package controllers

import(
  "net/http"
  "sequencing/models"
  "github.com/martini-contrib/render"
  "github.com/go-martini/martini"
  "strconv"
)

func GetBillOrders(req *http.Request, r render.Render, params martini.Params){
  billId, _ := strconv.Atoi(params["bill_id"])
  bill := models.Bill{Id: billId}
  result := bill.BillOrders()
  r.JSON(http.StatusOK, result)
}

func UpdateBillOrder(req *http.Request, r render.Render){
  record := map[string]interface{}{}
  parseJson(&record, req)
  price := record["price"].(float64)
  bo := models.BillOrder{
    OrderId: int(record["id"].(float64)),
  }
  billOrder := models.BillOrder{
    Price: price,
    ChargeCount: int(record["charge_count"].(float64)),
    OtherMoney: record["other_money"].(float64),
    Remark: record["remark"].(string),
  }
  billOrder.Money = billOrder.Price * float64(billOrder.ChargeCount) + billOrder.OtherMoney
  saved := models.Db.Model(&bo).UpdateColumns(&billOrder)
  renderDbResult(r, saved, billOrder)
}

func DeleteBillOrder(r render.Render, params martini.Params){
  id, _ := strconv.Atoi(params["id"])
  bo := models.BillOrder{OrderId: id}
  deleted := models.Db.Delete(&bo)
  if deleted.Error == nil {
    order := models.Order{Id: id}
    order.CheckStatus()
  }
  renderDbResult(r, deleted, bo)
}
