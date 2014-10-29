package controllers

import (
  "github.com/martini-contrib/render"
  "github.com/martini-contrib/sessions"
  "github.com/go-martini/martini"
  "strconv"
  "sequencing/models"
  "net/http"
  "encoding/json"
  "time"
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
      // because client_reaction_id should be related to reaction_id, so do not use Db.Save(order)
      order := models.NewOrder(int(firstClientId.(float64)), boardHead.Id, &models.Order{})
      orderCreated := models.Db.Save(&order)
      if orderCreated.Error == nil {
        ids := []int{}
        clearFailedOrder := func(order *models.Order, ids []int){
          models.Db.Exec("UPDATE client_reactions SET reaction_id = 0 WHERE id IN (?)", ids)
          models.Db.Delete(order)
        }
        for _, r := range records {
          // id is client_reactions id
          id := int(r["id"].(float64))
          ids = append(ids, id)
          primerId := int(r["primer_id"].(float64))
          vectorId := int(r["vector_id"].(float64))
          clientReaction := models.ClientReaction{Id: id}
          models.Db.First(&clientReaction)
          sample := models.Sample{
            Name: clientReaction.Sample,
            VectorId: vectorId,
            Resistance: clientReaction.Resistance,
            IsSplice: clientReaction.IsSplice,
            OrderId: order.Id,
          }
          // if sample name repeat, treat it as the same sample
          models.Db.Table("samples").Where("order_id = ? AND name = ?", order.Id, clientReaction.Sample).First(&sample)
          if sample.Id == 0 {
            sampleCreated := models.Db.Save(&sample)
            if sampleCreated.Error != nil {
              clearFailedOrder(&order, ids)
              break
            }
          }
          reaction := models.Reaction{
            OrderId: order.Id,
            SampleId: sample.Id,
            PrimerId: primerId,
            Remark: clientReaction.Remark,
          }
          reactionCreated := models.Db.Save(&reaction)
          if reactionCreated.Error == nil {
            models.Db.Model(&clientReaction).Update("reaction_id", reaction.Id)
          } else {
            clearFailedOrder(&order, ids)
            break
          }
          //log.Println(id, primerId, vectorId, head)
        }
      } else {
        r.JSON(http.StatusNotAcceptable, map[string]interface{}{"hint": orderCreated.Error.Error()})
      }
    } else {
      return
    }

  }
}

func GenerateRedoOrder(params martini.Params, req *http.Request, r render.Render) {
  boardHeadId, _ := strconv.Atoi(params["boardHeadId"])
  var ids []int
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&ids)
  if err == nil && len(ids) > 0 {
    var reactions []models.Reaction
    models.Db.Table("reactions").Where("reactions.id IN (?)", ids).Order("reactions.order_id, reactions.sample_id").Find(&reactions)
    orders := map[int]models.Order{}
    //samples := map[int]models.Sample{}
    now := time.Now()
    for _, r := range(reactions) {
      newOrder, ok := orders[r.OrderId]
      if !ok {
        o := models.Order{Id: r.OrderId}
        models.Db.First(&o)
        newOrder = models.Order{ClientId: o.ClientId, BoardHeadId: boardHeadId, CreateDate: now}
        newOrderP := &newOrder
        newOrderP.GenerateReworkSn(&o)
        models.Db.Where("sn = ?", newOrder.Sn).First(newOrderP)
        if newOrder.Id == 0 {
          models.Db.Save(newOrderP)
        }
        orders[r.OrderId] = newOrder
      }

      newSample := models.Sample{Id: r.SampleId}
      models.Db.First(&newSample)
      // relate the origin sample
      if newSample.ParentId == 0 {
        newSample.ParentId = newSample.Id
      }
      newSample.Id = 0
      newSample.BoardId = 0
      newSample.Hole = ""
      newSample.OrderId = newOrder.Id

      if r.ParentId == 0 {
        r.ParentId = r.Id
      }
      r.Id = 0
      r.BoardId = 0
      r.Hole = ""
      r.DilutePrimerId = 0
      newSample.Reactions = append(newSample.Reactions, r)
      models.Db.Save(&newSample)
      log.Println(newOrder)
    }
    for _, o := range orders {
      oP := &o
      oP.RelateReactions()
    }
    r.JSON(http.StatusOK, Ok_true)
  } else {
    r.JSON(http.StatusNotAcceptable, Ok_false)
    return
  }
}
