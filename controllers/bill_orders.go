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
