package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
  "encoding/json"
  "log"
)

func CreateOrder(params martini.Params, req *http.Request, r render.Render, session sessions.Session) {
  id, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: id}
  parseJson(&order, req)
  order.CreatorId = session.Get("id").(int)
  saved := models.Db.Save(&order)
  if saved.Error == nil {
    order.RelateReactions()
  }
  renderDbResult(r, saved, order)
}

func Reinterprete(req *http.Request, r render.Render, session sessions.Session){
  record := map[string]int{}
  parseJson(&record, req)
  id, ok := record["id"]
  interpreterId := session.Get("id").(int)
  if ok && id > 0 {
    order := models.Order{Id: id}
    order.Reinterprete(interpreterId)
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
  }
}

// show order`s reactions in bill_orderrs
func OrderReactions(params martini.Params, req *http.Request, r render.Render){
  id, _ := strconv.Atoi(params["id"])
  order := models.Order{Id: id}
  r.JSON(http.StatusOK, order.Reactions())
}

// receive client side reactions to generate an new order
func ReceiveOrder(req *http.Request, r render.Render){
  records := []map[string]interface{}{}
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&records)
  if err == nil && len(records) > 0 {
    // validate
    valid := true
    firstClientId := records[0]["client_id"]
    firstBoardHead := records[0]["board_head"]
    for _, r := range records {
      if r["client_id"] != firstClientId {
        valid = false
        break
      }
      if r["board_head"] != firstBoardHead {
        valid = false
        break
      }
    }
    if !valid {
      r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": "invalid"})
      return
    }

    head := firstBoardHead.(string)
    var boardHead models.BoardHead
    models.Db.Where("name = ? AND board_type = 'sample' AND available = 1", head).First(&boardHead)
    if boardHead.Id > 0 {
      today := models.Today()
      maxNumber = Db.Select("MAX(number)").Where("create_date = ? AND board_head_id = ?", today, boardHead.Id)
      order := models.Order{CreateDate: today, Number: maxNumber + 1, ClientId: clientId, BoardHeadId: boardHead.Id}
    } else {
      return
    }

    for _, r := range records {
      id := int(r["id"].(float64))
      primerId := int(r["primer_id"].(float64))
      vectorId := int(r["vector_id"].(float64))
      log.Println(id, primerId, vectorId, head)
    }
  }
}
