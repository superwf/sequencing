package models
import (
  "net/http"
  "strings"
  "strconv"
  "encoding/json"
)

type DilutePrimer struct {
  Id int `json:"id"`
  PrimerId int `json:"primer_id"`
  Status string `json:"status"`
  Remark string `json:"remark"`
  Creator
}

func DilutingPrimer(req *http.Request)([]map[string]interface{}) {
  var reactionIds []string
  rows, _ := Db.Table("reactions").Select("reactions.id").Joins("INNER JOIN samples ON samples.id = reactions.sample_id INNER JOIN boards ON boards.id = samples.board_id").Where("reactions.dilute_primer_id = 0 AND boards.status = 'run'").Rows()
  for rows.Next() {
    var id int
    rows.Scan(&id)
    reactionIds = append(reactionIds, strconv.Itoa(id))
  }
  result := []map[string]interface{}{}
  if len(reactionIds) == 0 {
    return result
  }
  reactionSql := strings.Join(reactionIds, ",")
  //var primerIds = []string
  rows, _ = Db.Table("reactions").Select("DISTINCT reactions.primer_id").Where("reactions.id IN (" + reactionSql + ")").Rows()
  for rows.Next() {
    var id, reactions_count int
    var primer, primer_board, primer_hole, origin_thickness, primer_remark string
    rows.Scan(&id)
    Db.Table("primers").Select("primers.name, primers.hole, primers.origin_thickness, boards.sn, primers.remark").Joins("INNER JOIN boards ON primers.board_id = boards.id").Where("primers.id = " + strconv.Itoa(id)).Row().Scan(&primer, &primer_hole, &origin_thickness, &primer_board, &primer_remark)
    Db.Table("reactions").Joins("INNER JOIN samples ON samples.id = reactions.sample_id INNER JOIN orders ON orders.id = samples.order_id INNER JOIN clients ON orders.client_id = clients.id").Where("reactions.id IN (" + reactionSql + ") AND reactions.primer_id = ?", id).Count(&reactions_count)
    orderRows, _ := Db.Table("reactions").Select("DISTINCT orders.sn, clients.name").Joins("INNER JOIN samples ON samples.id = reactions.sample_id INNER JOIN orders ON orders.id = samples.order_id INNER JOIN clients ON orders.client_id = clients.id").Where("reactions.id IN (" + reactionSql + ") AND reactions.primer_id = ?", id).Rows()
    var orderClient []string
    for orderRows.Next() {
      var order, client string
      orderRows.Scan(&order, &client)
      orderClient = append(orderClient, order + " / " + client)
    }
    var sampleBoard []string
    sampleBoardRows, _ := Db.Table("boards").Select("DISTINCT boards.sn").Joins("INNER JOIN samples ON boards.id = samples.board_id INNER JOIN reactions ON samples.id = reactions.sample_id").Where("reactions.id IN(" + reactionSql + ") AND reactions.primer_id = ?", id).Rows()
    for sampleBoardRows.Next() {
      var board string
      sampleBoardRows.Scan(&board)
      sampleBoard = append(sampleBoard, board)
    }
    d := map[string]interface{}{
      "primer_id": id,
      "primer": primer,
      "primer_board": primer_board,
      "order_client": orderClient,
      "sample_board": sampleBoard,
      "origin_thickness": origin_thickness,
      "reactions_count": reactions_count,
      "primer_remark": primer_remark,
    }
    result = append(result, d)
  }
  return result
}

func CreateDilutePrimer(req *http.Request) {
  var records []DilutePrimer
  decoder := json.NewDecoder(req.Body)
  err := decoder.Decode(&records)
  if err != nil {
    panic(err)
  }
  for _, r := range(records) {
    Db.Save(&r)
    Db.Begin()
    if r.Id > 0 {
      Db.Exec("UPDATE reactions, samples, boards SET reactions.dilute_primer_id = " + strconv.Itoa(r.Id) + " WHERE boards.status = 'run' AND reactions.primer_id = " + strconv.Itoa(r.PrimerId) + " AND reactions.dilute_primer_id = 0 AND samples.id = reactions.sample_id AND boards.id = samples.board_id")
      var count int
      Db.Table("reactions").Where("dilute_primer_id = ?", r.Id).Count(&count)
      if count == 0 {
        Db.Rollback()
      }
    } else {
      Db.Rollback()
    }
    Db.Commit()
  }
}
